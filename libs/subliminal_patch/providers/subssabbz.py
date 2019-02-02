# -*- coding: utf-8 -*-
import logging
import re
import io
import os
from random import randint
from bs4 import BeautifulSoup
from zipfile import ZipFile, is_zipfile
from rarfile import RarFile, is_rarfile
from requests import Session
from guessit import guessit
from subliminal_patch.providers import Provider
from subliminal_patch.subtitle import Subtitle
from subliminal_patch.utils import sanitize
from subliminal.exceptions import ProviderError
from subliminal.utils import sanitize_release_group
from subliminal.subtitle import guess_matches
from subliminal.video import Episode, Movie
from subliminal.subtitle import fix_line_ending
from subzero.language import Language
from .utils import FIRST_THOUSAND_OR_SO_USER_AGENTS as AGENT_LIST

logger = logging.getLogger(__name__)

class SubsSabBzSubtitle(Subtitle):
    """SubsSabBz Subtitle."""
    provider_name = 'subssabbz'

    def __init__(self, langauge, filename, type):
        super(SubsSabBzSubtitle, self).__init__(langauge)
        self.langauge = langauge
        self.filename = filename
        self.type = type

    @property
    def id(self):
        return self.filename

    def get_matches(self, video):
        matches = set()

        video_filename = video.name
        video_filename = os.path.basename(video_filename)
        video_filename, _ = os.path.splitext(video_filename)
        video_filename = sanitize_release_group(video_filename)

        subtitle_filename = self.filename
        subtitle_filename = os.path.basename(subtitle_filename)
        subtitle_filename, _ = os.path.splitext(subtitle_filename)
        subtitle_filename = sanitize_release_group(subtitle_filename)

        if video_filename == subtitle_filename:
             matches.add('hash')

        matches |= guess_matches(video, guessit(self.filename, {'type': self.type}))

        matches.add(id(self))
        return matches


class SubsSabBzProvider(Provider):
    """SubsSabBz Provider."""
    languages = {Language('por', 'BR')} | {Language(l) for l in [
        'bul', 'eng'
    ]}

    def initialize(self):
        self.session = Session()
        self.session.headers['User-Agent'] = AGENT_LIST[randint(0, len(AGENT_LIST) - 1)]
        self.session.headers["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
        self.session.headers["Accept-Language"] = "en-US,en;q=0.5"
        self.session.headers["Accept-Encoding"] = "gzip, deflate, br"
        self.session.headers["DNT"] = "1"
        self.session.headers["Connection"] = "keep-alive"
        self.session.headers["Upgrade-Insecure-Requests"] = "1"
        self.session.headers["Cache-Control"] = "max-age=0"

    def terminate(self):
        self.session.close()

    def query(self, language, video):
        subtitles = []
        isEpisode = isinstance(video, Episode)

        params = {
            'act': 'search',
            'movie': '',
            'select-language': '2',
            'upldr': '',
            'yr': '',
            'release': ''
        }

        if isEpisode:
            params['movie'] = "%s %02d %02d" % (sanitize(video.series), video.season, video.episode)
        else:
            params['yr'] = video.year
            params['movie'] = (video.title)

        if language == 'en' or language == 'eng':
            params['select-language'] = 1

        logger.info('Searching subtitle %r', params)
        response = self.session.post('http://subs.sab.bz/index.php?', params=params, allow_redirects=False, timeout=10, headers={
            'Referer': 'http://subs.sab.bz/',
            })

        response.raise_for_status()

        if response.status_code != 200:
            logger.debug('No subtitles found')
            return subtitles

        soup = BeautifulSoup(response.content, 'html.parser')
        rows = soup.findAll('tr', {'class': 'subs-row'})

        # Search on first 10 rows only
        for row in rows[:10]:
            a_element_wrapper = row.find('td', { 'class': 'c2field' })
            if a_element_wrapper:
                element = row.find('a')
                if element:
                    link = element.get('href')
                    logger.info('Found subtitle link %r', link)
                    subtitles = subtitles + self.download_archive_and_add_subtitle_files(link, language, video)

        return subtitles

    def list_subtitles(self, video, languages):
        return [s for l in languages for s in self.query(l, video)]

    def download_subtitle(self, subtitle):
        pass

    def process_archive_subtitle_files(self, archiveStream, language, video):
        subtitles = []
        type = 'episode' if isinstance(video, Episode) else 'movie'
        for file_name in archiveStream.namelist():
            if file_name.lower().endswith(('.srt', '.sub')):
                logger.info('Found subtitle file %r', file_name)
                subtitle = SubsSabBzSubtitle(language, file_name, type)
                subtitle.content = archiveStream.read(file_name)
                subtitles.append(subtitle)
        return subtitles

    def download_archive_and_add_subtitle_files(self, link, language, video ):
        logger.info('Downloading subtitle %r', link)
        request = self.session.get(link, headers={
            'Referer': 'http://subs.sab.bz/index.php?'
            })
        request.raise_for_status()

        archive_stream = io.BytesIO(request.content)
        if is_rarfile(archive_stream):
            return self.process_archive_subtitle_files( RarFile(archive_stream), language, video )
        elif is_zipfile(archive_stream):
            return self.process_archive_subtitle_files( ZipFile(archive_stream), language, video )
        else:
            raise ValueError('Not a valid archive')
