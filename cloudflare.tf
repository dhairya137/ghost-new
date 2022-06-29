provider "cloudflare" {
  email   = "dhairya00798@gmail.com"
  api_key = "a8e9e423a3b90864720a4c148b04ff30c9312"
}

data "cloudflare_zone" "dptools" {
  name = "dptools.me"
}

resource "cloudflare_record" "www" {
  zone_id = data.cloudflare_zone.dptools.id
  name    = "test"
  value   = "203.0.113.10"
  type    = "A"
  proxied = true
}

output "domain_name" {
  value = cloudflare_record.www.name
}
output "domain_ip" {
  value = cloudflare_record.www.value
}
