def cmResult = runService('createContactMech', [
        contactMechTypeId : 'TELECOM_NUMBER',
        userLogin         : parameters.userLogin
])
if (ServiceUtil.isError(cmResult)) return cmResult
def contactMechId = cmResult.contactMechId

def telResult = runService('createTelecomNumber', [
        contactMechId : contactMechId,
        countryCode   : parameters.countryCode,
        areaCode      : parameters.areaCode,
        contactNumber : parameters.contactNumber,
        askForName    : parameters.askForName,
        userLogin     : parameters.userLogin
])
if (ServiceUtil.isError(telResult)) return telResult
return [contactMechId: contactMechId]