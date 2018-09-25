package models

import (
	"encoding/json"
	"github.com/influxdata/influxdb/client/v2"
	"github.com/notyim/gaia/db/influxdb"
	"github.com/notyim/gaia/types"
	"log"
	"time"
)

type CheckResult types.HTTPCheckResponse

func (c *CheckResult) TotalTimeAsInt() int {
	return int(c.Time["Total"] / time.Millisecond)
}

func (c *CheckResult) ToJson() []byte {
	body, err := json.Marshal(c)
	if err != nil {
		return nil
	}
	return body
}

func (c *CheckResult) Point() *client.Point {
	tags := map[string]string{
		"check_id": c.CheckID,
	}

	fields := map[string]interface{}{
		"error": c.Error,
	}

	for k, v := range c.Time {
		fields["time_"+k] = int(v / time.Millisecond)
	}
	fields["body_size"] = len(c.Body)
	fields["status"] = c.Status
	fields["status_code"] = c.StatusCode
	fields["from_ip"] = c.FromIp
	fields["from_region"] = c.FromRegion

	point, err := client.NewPoint("http_response", tags, fields, c.CheckedAt)
	if err != nil {
		log.Println("Cannot create point", err)
		return nil
	}

	return point
}

func (c *CheckResult) Save() {
	log.Println("FLush", c.CheckID, "to InfluxDB")
	if err := influxdb.WritePoint(c.Point()); err != nil {
		log.Println("Cannot write batch points to influxdb", err)
	}
}
