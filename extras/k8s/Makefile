ns := noty
k := kubectl -n $(ns)

default: tls

tls:
	echo "Pre-copied tls.key and tls.crt into this directory"
	$(k) delete secret tls || true
	$(k) create secret tls tls --key cert/noty.im.key --cert cert/fullchain.cer
