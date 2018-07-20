environment = {
  dev = {
    location = "westus2"
    db.edition = "Basic"
    db.sku = "Basic"

    webapp.tier = "Free"
    webapp.sku = "F1"
    # this has to be a comma-separated list since an array causes a "not homogeneous types" error
    # for no slots, leave as an empty string
    webapp.slots = "" 
  }

  uat = {
    location = "westus2"
    db.edition = "Basic"
    db.sku = "Basic"

    webapp.tier = "Standard"
    webapp.sku = "S1"
    # this has to be a comma-separated list since an array causes a "not homogeneous types" error
    # for no slots, leave as an empty string
    webapp.slots = "blue,yellow" 
  }
}

created_by = "colin"