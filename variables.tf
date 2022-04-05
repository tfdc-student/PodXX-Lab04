variable "password" {
    type = string
    description = "vSphere password"
}

variable "Pod" {
    type = string
    default = "PodXX"
    description = "Change XX with your pod number. If below 10, use 0X notation"
}