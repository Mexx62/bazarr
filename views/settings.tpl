<html>
	<head>
		<!DOCTYPE html>
		<script src="/static/jquery/jquery-latest.min.js"></script>
		<script src="/static/semantic/semantic.min.js"></script>
		<script src="/static/jquery/tablesort.js"></script>
		<link rel="stylesheet" href="/static/semantic/semantic.min.css">
		
		<link rel="apple-touch-icon" sizes="120x120" href="/static/apple-touch-icon.png">
		<link rel="icon" type="image/png" sizes="32x32" href="/static/favicon-32x32.png">
		<link rel="icon" type="image/png" sizes="16x16" href="/static/favicon-16x16.png">
		<link rel="manifest" href="/static/manifest.json">
		<link rel="mask-icon" href="/static/safari-pinned-tab.svg" color="#5bbad5">
		<link rel="shortcut icon" href="/static/favicon.ico">
		<meta name="msapplication-config" content="/static/browserconfig.xml">
		<meta name="theme-color" content="#ffffff">
		
		<title>Settings - Bazarr</title>
		
		<style>
			body {
				background-color: #272727;
			}
			#divmenu {
				background-color: #272727;
				opacity: 0.9;
				padding-top: 2em;
				padding-bottom: 1em;
				padding-left: 1em;
				padding-right: 128px;
			}
			#fondblanc {
				background-color: #ffffff;
				border-radius: 0px;
				box-shadow: 0px 0px 5px 5px #ffffff;
				margin-top: 32px;
				margin-bottom: 3em;
				padding: 1em;
			}
		</style>
	</head>
	<body>
		<div id='loader' class="ui page dimmer">
		   	<div class="ui indeterminate text loader">Loading...</div>
		</div>
		<div id="divmenu" class="ui container">
			<div style="background-color:#272727;" class="ui inverted borderless labeled icon huge menu four item">
				<a href="/"><img style="margin-right:32px;" class="logo" src="/static/logo128.png"></a>
				<div style="height:80px;" class="ui container">
					<a class="menu item" href="/">
						<i class="play icon"></i>
						Series
					</a>
					<a class="menu item" href="/history">
						<i class="wait icon"></i>
						History
					</a>
					<a class="menu item" href="/settings">
						<i class="settings icon"></i>
						Settings
					</a>
					<a class="menu item" href="/system">
						<i class="laptop icon"></i>
						System
					</a>
				</div>
			</div>
		</div>
			
		<div id="fondblanc" class="ui container">
			<div class="ui top attached tabular menu">
				<a class="item active" data-tab="general">General</a>
				<a class="item" data-tab="sonarr">Sonarr</a>
				<a class="item" data-tab="subliminal">Subliminal</a>
			</div>
			<form>
				<div class="ui bottom attached tab segment active" data-tab="general">
					<div class="ui container"><button class="ui blue right floated button">Save</button></div>
					<br>
					<div class="ui dividing header">Bazarr settings</div>
						<div class="twelve wide column">
							<div class="ui grid">
								<div class="middle aligned row">
									<div class="right aligned four wide column">
										<label>Listening IP address</label>
									</div>
									<div class="eleven wide column">
										<div class="ui input">
											<input type="text" value="{{settings_general[0]}}">
										</div>
									</div>
								</div>

								<div class="middle aligned row">
									<div class="right aligned four wide column">
										<label>Listening port</label>
									</div>
									<div class="eleven wide column">
										<div class="ui input">
											<input type="text" value="{{settings_general[1]}}">
										</div>
									</div>
								</div>

								<div class="middle aligned row">
									<div class="right aligned four wide column">
										<label>Base URL</label>
									</div>
									<div class="eleven wide column">
										<div class="ui input">
											%if settings_general[2] == None:
											%	base_url = "/"
											%else:
											%	base_url = settings_general[2]
											%end
											<input type="text" value="{{base_url}}">
										</div>
									</div>
								</div>
					</div>

					<div class="ui dividing header">Remote Path Mappings</div>
						<div class="twelve wide column">
							<div class="ui grid">
								%import ast
								%path_substitutions = ast.literal_eval(settings_general[3])
								%for x in range(0, 5):
								%	path = []
								%	try:
								%		path = path_substitutions[x]
								%	except IndexError:
								%		path = ["", ""]
								%	end
							    <div class="middle aligned row">
							    	<div class="right aligned four wide column">
							    		
							    	</div>
									<div class="four wide column">
										<div class="ui fluid input">
											<input type="text" value="{{path[0]}}">
										</div>
									</div>
									<div class="center aligned column">
										<i class="arrow circle right icon"></i>
									</div>
									<div class="four wide column">
										<div class="ui fluid input">
											<input type="text" value="{{path[1]}}">
										</div>
									</div>
								</div>
								%end
							</div>
						</div>
					</div>
				</div>
				<div class="ui bottom attached tab segment" data-tab="sonarr">
					<div class="ui container"><button class="ui blue right floated button">Save</button></div>
					<br>
					<div class="ui dividing header">Sonarr settings</div>
						<div class="twelve wide column">
							<div class="ui grid">
								<div class="middle aligned row">
									<div class="right aligned four wide column">
										<label>Listening IP address</label>
									</div>
									<div class="eleven wide column">
										<div class="ui input">
											<input type="text" value="{{settings_sonarr[0]}}">
										</div>
									</div>
								</div>

								<div class="middle aligned row">
									<div class="right aligned four wide column">
										<label>Listening port</label>
									</div>
									<div class="eleven wide column">
										<div class="ui input">
											<input type="text" value="{{settings_sonarr[1]}}">
										</div>
									</div>
								</div>

								<div class="middle aligned row">
									<div class="right aligned four wide column">
										<label>Base URL</label>
									</div>
									<div class="eleven wide column">
										<div class="ui input">
											<input type="text" value="{{settings_sonarr[2]}}">
										</div>
									</div>
								</div>

								<div class="middle aligned row">
									<div class="right aligned four wide column">
										<label>SSL enabled</label>
									</div>
									<div class="eleven wide column">
										<div id="sonarr_ssl_div" class="ui toggle checkbox" data-ssl={{settings_sonarr[3]}}>
									    	<input type="checkbox">
									    	<label></label>
									    </div>
									</div>
								</div>

								<div class="middle aligned row">
									<div class="right aligned four wide column">
										<label>API key</label>
									</div>
									<div class="five wide column">
										<div class="ui fluid input">
											<input type="text" value="{{settings_sonarr[4]}}">
										</div>
									</div>
								</div>
							</div>
						</div>
				</div>
				<div class="ui bottom attached tab segment" data-tab="subliminal">
					<div class="ui container"><button class="ui blue right floated button">Save</button></div>
					<br>
					<div class="ui dividing header">Subtitles providers</div>
						<div class="twelve wide column">
							<div class="ui grid">
								<div class="middle aligned row">
									<div class="right aligned four wide column">
										<label>Enabled providers</label>
									</div>
									<div class="eleven wide column">
										<select name="settings_providers" id="settings_providers" multiple="" class="ui fluid selection dropdown">
											<option value="">Providers</option>
											%enabled_providers = []
											%for provider in settings_providers:
											<option value="{{provider[0]}}">{{provider[0]}}</option>
											%if provider[1] == True:
											%	enabled_providers.append(str(provider[0]))
											%end
											%end
										</select>
									</div>
								</div>
							</div>
						</div>
					<div class="ui dividing header">Subtitles languages</div>
						<div class="twelve wide column">
							<div class="ui grid">
								<div class="middle aligned row">
									<div class="right aligned four wide column">
										<label>Enabled languages</label>
									</div>
									<div class="eleven wide column">
										<select name="settings_languages" id="settings_languages" multiple="" class="ui fluid selection dropdown">
											<option value="">Languages</option>
											%enabled_languages = []
											%for language in settings_languages:
											<option value="{{language[1]}}">{{language[2]}}</option>
											%if language[3] == True:
											%	enabled_languages.append(str(language[1]))
											%end
											%end
										</select>
									</div>
								</div>
							</div>
						</div>
				</div>
			</form>
		</div>
	</body>
</html>


<script>
	$('.menu .item')
		.tab()
	;

	$('a.menu').click(function(){
		$('#loader').addClass('active');
	})

	if ($('#sonarr_ssl_div').data("ssl") == "True") {
				$("#sonarr_ssl_div").checkbox('check');
			} else {
				$("#sonarr_ssl_div").checkbox('uncheck');
			}
	
	$('#settings_providers').dropdown('clear');
	$('#settings_providers').dropdown('set selected',{{!enabled_providers}});
	$('#settings_languages').dropdown('clear');
	$('#settings_languages').dropdown('set selected',{{!enabled_languages}});

	$('#settings_providers').dropdown();
	$('#settings_languages').dropdown();
</script>