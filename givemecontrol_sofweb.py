#!/usr/bin/env python3
import socket
import socks
import urllib3
import mechanize

def connectTOR():
		socks.setdefaultproxy(socks.PROXY_TYPE_SOCKS5, "127.0.0.1", 9050, True)
		socket.socket = socks.socksocket
if __name__ == "__main__":
		connectTOR()
		browser = mechanize.Browser()
		browser.open("http://wikipedia.com")
		try:
				for form in browser.forms():
					print("[*] Form Name %s" %(form.name))
		except:
			print("error")
