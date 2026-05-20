import org.apache.ofbiz.service.ServiceUtil
def partyResult = runService('createParty', [

        partyTypeId : parameters.partyTypeId ?: 'PARTY_GROUP',
        statusId    : parameters.statusId,
        userLogin   : parameters.userLogin
])
if (ServiceUtil.isError(partyResult)) return partyResult

def partyId = partyResult.partyId

def groupResult = runService('createPartyGroup', [
        partyId       : partyId,
        groupName     : parameters.groupName,
        numEmployee   : parameters.numEmployee,
        annualRevenue : parameters.annualRevenue,
        userLogin     : parameters.userLogin
])
if (ServiceUtil.isError(groupResult)) return groupResult

return [partyId: partyId]