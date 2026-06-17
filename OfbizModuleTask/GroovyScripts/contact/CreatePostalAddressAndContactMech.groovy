def cmResult = runService('createContactMech', [
        contactMechTypeId : 'POSTAL_ADDRESS',
        userLogin         : parameters.userLogin
])
if (ServiceUtil.isError(cmResult)) return cmResult
def contactMechId = cmResult.contactMechId

def addrResult = runService('createPostalAddress', [
        contactMechId       : contactMechId,
        toName              : parameters.toName,
        attnName            : parameters.attnName,
        address1            : parameters.address1,
        address2            : parameters.address2,
        city                : parameters.city,
        postalCode          : parameters.postalCode,
        stateProvinceGeoId  : parameters.stateProvinceGeoId,
        countryGeoId        : parameters.countryGeoId,
        userLogin           : parameters.userLogin
])
if (ServiceUtil.isError(addrResult)) return addrResult
return [contactMechId: contactMechId]