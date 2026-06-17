import org.apache.ofbiz.entity.GenericValue
import org.apache.ofbiz.service.ServiceUtil
// Step 1: create the Party row (partyId auto-sequenced)
def partyResult = runService('createParty', [
        partyTypeId : parameters.partyTypeId ?: 'PERSON',
        statusId    : parameters.statusId,
        description : parameters.description,
        userLogin   : parameters.userLogin
])
if (ServiceUtil.isError(partyResult)) return partyResult

def partyId = partyResult.partyId

// Step 2: create the Person row using the generated partyId
def personResult = runService('createPerson', [
        partyId     : partyId,
        salutation  : parameters.salutation,
        firstName   : parameters.firstName,
        middleName  : parameters.middleName,
        lastName    : parameters.lastName,
        birthDate   : parameters.birthDate,
        height      : parameters.height,
        weight      : parameters.weight,
        userLogin   : parameters.userLogin
])
if (ServiceUtil.isError(personResult)) return personResult

return [partyId: partyId]