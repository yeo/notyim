ns := noty
k := kubectl -n $(ns)

tls:
	echo "Pre-copied tls.key and tls.crt into this directory"
	$(k) delete secret tls || true
	$(k) create secret tls tls --key noty.im.key --cert fullchain.cer
