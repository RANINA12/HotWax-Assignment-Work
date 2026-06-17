def cmResult = runService('createContactMech', [
        contactMechTypeId : 'EMAIL_ADDRESS',
        infoString        : parameters.infoString,
        userLogin         : parameters.userLogin
])
if (ServiceUtil.isError(cmResult)) return cmResult
return [contactMechId: cmResult.contactMechId]