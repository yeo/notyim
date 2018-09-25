package caa

import (
	"github.com/miekg/dns"
)

// Credit: https://github.com/kofj/caa-validator/blob/master/cli/main.go
type Checker struct {
	resolver conn, err := dns.DialTimeout("tcp", *ns, timeout)
}

func check(domain string) (error){
	c := Checker{ }
	conn, err := dns.DialTimeout("tcp", *ns, timeout)

	if err != nil {
		return err
	}

	c.resolver = conn

	req := new(dns.Msg)
	req.SetQuestion(name, dns.TypeCAA)
	err = conn.WriteMsg(req)
	if err != nil {
		return err
	}

// read msg
	resp, err2 := conn.ReadMsg()
	if err2 != nil {
		fmt.Println(err2)
		return
	}
	conn.Close()

	var nocaa bool
	var records string
	for k := range resp.Answer {
		rr := resp.Answer[k]
		switch rr.(type) {
		case *dns.CAA:
			caa := rr.(*dns.CAA)
			records += fmt.Sprintf("%s\t%d\tIN\t%d\t %s %s\n",
				caa.Header().Name, caa.Header().Ttl, caa.Flag, caa.Tag, caa.Value)

		default:
			nocaa = true
			break
		}
	}

	if nocaa || records == "" {
		return error.New("NoCAA")
	} else {
		return records
	}
}

