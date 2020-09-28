set -U __codestats_xp (math $__codestats_xp + 0)
set -U __codestats_last_pulse 0
set -U __codestats_pulse_lock 0 # false

set __codestats_version "0.1.1"

if test -z $CODESTATS_API_URL
	set -U CODESTATS_API_URL "https://codestats.net/api/my/pulses"
end

function __codestats__gather_runner -d "Runs __codestats_gather as a background job (maybe it's faster this way)" -e fish_postexec
	__codestats__gather $argv &
end

function __codestats__gather -d "Gathers XP" 
	set -U __codestats_xp (math $__codestats_xp + (string length $argv))

	if test $__codestats_pulse_lock -eq 0
		if test (date +%s) -gt (math $__codestats_last_pulse + 30)
			if test $__codestats_xp -gt 0
				set -U __codestats_pulse_lock 1
				__codestats__pulse &
			end
		end
	end
end

function __codestats__pulse -d "Sends accumulated XP" 
	if test -z $CODESTATS_API_KEY
		set_color magenta; echo -n "codestats-fish"
		set_color normal; echo -n ": "
		set_color red; echo -n "CODESTATS_API_KEY is empty!"
		false
	end

	set -l datetime (date "+%Y-%m-%dT%T%z")
	set -l payload (printf '{ "coded_at": "%s", "xps": [{ "language": "Terminal (Fish)", "xp": %s }]}' $datetime $__codestats_xp)

	curl \
		--header "Content-Type: application/json" \
		--header "X-API-Token: $CODESTATS_API_KEY" \
		--user-agent "codestats-fish/$__codestats_version" \
		--data "$payload" \
		--request POST \
		--silent \
		--output /dev/null \
		--write-out "%{http_code}" \
		"$CODESTATS_API_URL" \
		| __codestats__response
end

function __codestats__response -d "Checks CodeStats API response code"
	cat | read --line status_code
	switch $status_code
		case "2*"
			set -U __codestats_xp 0
			set -U __codestats_last_pulse (date +%s)
	end
	set -U __codestats_pulse_lock 0
end

function __codestats__exit -d "Cleans up" -e fish_exit
	if test $__codestats_xp -gt 0
		__codestats__pulse
	end
	set -U __codestats_pulse_lock 0
end
