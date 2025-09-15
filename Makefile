build:
	go build -o bin/antifilter cmd/main.go

pull-vendors:
	git submodule update --init --recursive --remote -f

# make build gen-youtube
gen-youtube:
	echo > cidr4.full.ignore.txt
	cat vendor/iplist-youtube/lists/cidr4.txt >> cidr4.full.ignore.txt
	echo "\n" >> cidr4.full.ignore.txt
	cat cidr/youtube_cidr4.txt >> cidr4.full.ignore.txt
	bin/antifilter cidr4.full.ignore.txt routes/youtube-ipv4.bat

# make build gen-facebook
gen-facebook:
	bin/antifilter vendor/facebook-ip-lists/facebook_ipv4_cidr_blocks.lst routes/facebook-ipv4.bat

# make build gen-chatgpt
gen-chatgpt:
	bin/antifilter cidr/chatgpt_cidr4.txt routes/chatgpt-ipv4.bat

# make build gen-medium
gen-medium:
	bin/antifilter cidr/medium_cidr4.txt routes/medium-ipv4.bat

# make build gen-rutracker
gen-rutracker:
	bin/antifilter cidr/rutracker_cidr4.txt routes/rutracker-ipv4.bat

# make build gen-cloudflare
gen-cloudflare:
	curl https://www.cloudflare.com/ips-v4 -o vendor/cloudflare/ipv-4.txt
	bin/antifilter vendor/cloudflare/ipv-4.txt  routes/cloudflare-ipv4.bat

# make build gen-discord
gen-discord:
	bin/antifilter cidr/discord_cidr4.txt routes/discrod-ipv4.bat

# make build gen-telegram
gen-telegram:
	bin/antifilter cidr/telegram_cidr4.txt routes/telegram-ipv4.bat

# make build gen-copilot
gen-copilot:
	bin/antifilter cidr/copilot_cidr4.txt routes/copilot-ipv4.bat

# make build gen-all slice-routes
gen-all: gen-youtube
gen-all: gen-facebook
gen-all: gen-chatgpt
gen-all: gen-medium
gen-all: gen-rutracker
gen-all: gen-cloudflare
gen-all: gen-discord
gen-all: gen-telegram
gen-all: gen-copilot

slice-routes:
	@rm routes/all-ipv4-*
	@cat routes/*-ipv4.bat | split -l 1024 - routes/all-ipv4-
	@for f in routes/all-ipv4-*; do \
		mv "$$f" "$${f%*}.bat"; \
	done
