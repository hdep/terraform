variable "vsphere_user" {}
variable "vsphere_password" {}
variable "vsphere_server" {
    type = string
    default = "vcenter.domain.local"

}

variable "datacenter" {}
variable "cluster" {}
variable "datastore" {}
variable "network" {}


variable "template_name" {}
variable "vm_name" {}
variable "domain" {}
variable "vm_ip" {}
variable "netmask" {}
variable "gateway" {}
variable "timezone" {
    type = string
    default = "Europe/Paris"
}
variable "dns_server_list" {
    type = list(string)
    default = ["9.9.9.9"]
}
variable "dns_suffix_list" {
    type = list(string)
    default = ["domain.com","private.domain.com"]
}
variable "root_password" {
    type = string
}
