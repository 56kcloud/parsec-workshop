group "default" {
  #targets = ["parsec", "parsec_0_7_0", "parsec_0_8_1"]
  targets = ["parsec_0_8_1"]
}
target "generic" {
  context = "."
  args = {
    REGISTRY = "parallaxsecond"
  }
}
target "parsec" {
  inherits = ["generic"]
  context  = "./parsec"
  args = {
    PARSEC_BRANCH = "main"
  }
  tags = [
    "parallaxsecond/parsec:latest"
  ]
}
target "parsec_0_8_1" {
  inherits = ["parsec"]
  args = {
    PARSEC_BRANCH = "0.8.1"
  }
  tags = [
    "parallaxsecond/parsec:0.8.1"
  ]
}
target "parsec_0_7_0" {
  inherits = ["parsec"]
  args = {
    PARSEC_BRANCH = "0.7.0"
  }
  tags = [
    "parallaxsecond/parsec:0.7.0"
  ]
}
