trigger ContactTrigger on Contact (after insert,after update,after delete) {

    if(Trigger.isAfter && Trigger.isInsert)
    {
        List<Contact> contactList = Trigger.isDelete?Trigger.old:Trigger.new;
        ContactTriggerHandler.updateContactsCount(contactList);
    }

    if(Trigger.isAfter && Trigger.isUpdate)
    {
        List<Contact> contactList = Trigger.isDelete?Trigger.old:Trigger.new;
        ContactTriggerHandler.updateContactsCount(contactList);
    }

    if(Trigger.isAfter && Trigger.isDelete)
    {
        List<Contact> contactList = Trigger.isDelete?Trigger.old:Trigger.new;
        ContactTriggerHandler.updateContactsCount(contactList);
    }


}