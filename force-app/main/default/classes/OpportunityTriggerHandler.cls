public with sharing class OpportunityTriggerHandler {
    
    public static void updateOppty(List<Account> accList,Map<Id,Account> accoldMap)
    {
        List<Opportunity> oppList = new List<Opportunity>();

        for(Account acc:accList)
        {
            if(accoldMap.get(acc.Id).Industry != acc.Industry && acc.Industry == 'Agriculture')
            {       
                Opportunity opp = new Opportunity(Stage='Prospecting',Amount='40000',CloseDate=System.today()+90);
                oppList.add(opp);
            }
        
        }

        if(!oppList.isEmpty())
        OpportunityTriggerHandler.insertOppList(oppList);
    }   

    public static void createOppty(List<Account> accList)
    {
        List<Opportunity> oppList = new List<Opportunity>();

        for(Account acc:accList)
        {
            if(acc.Industry == 'Agriculture')
            {
                Opportunity opp = new Opportunity(Stage='Prospecting',Amount='40000',CloseDate=System.today()+90);
                oppList.add(opp);
            }
        }

        if(!oppList.isEmpty())
        OpportunityTriggerHandler.insertOppList(oppList);
    }

    public static void insertOppList(List<Opportunity> oppList)
    {
        insert oppList;
    }

    public static void deleteOppty(List<Opportunity> oppList)
    {
        Profile adminProfileId = [SELECT Id from Profile WHERE Name='System Administrator' LIMIT 1];

        for(Opportunity opp:oppList)
        {
            if(opp.StageName == 'Closed' && System.UserInfo.profileId != adminProfileId)
            {
            opp.addError('Can\'t delete with System Admin Profile');
            }
        }
    }

    public static void updateOppty(List<Opportunity> oppList) 
    {
        List<Opportunity> oppListNew = new List<Opportunity>();
        for(Opportunity opp:oppList)
        {
            if(opp.Status == 'Closed Won')
            {
                oppListNew.add(opp);
            }
        }

        List<Opportunity> oportunities = [Select Id, OwnerId, Name, StageName, Account.OwnerId, Owner.Email, Account.Owner.Email
        From Opportunity Where Id IN :Trigger.newMap.keySet()
        AND StageName='Closed Won'];

        OpportunityTriggerHandler.sendEmail(opportunities);
    }


    public static sendEmail(List<Opportunity> oppList)
    {
        if(!oppList.isEmpty())
        {
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            
            for(Opportunity opp : oppList) {
                Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
                
                // Check if Opportunity owner and account owner are same
                // if yes, then set only 1 email address to the 'To Address' so that 2 emails are not sent to the same owner
                // else add email of both owners
                // set subject and text body of the email as well and add the email to list of emails
                if(opp.OwnerId == opp.Account.OwnerId) {
                    emailMessage.setToAddresses(new List<String> {opp.Owner.Email});
                }
                else {
                    emailMessage.setToAddresses(new List<String> {opp.Owner.Email, opp.Account.Owner.Email});
                }
                emailMessage.setSubject('Opportunity - Closed Won');
                emailMessage.setPlainTextBody('Below Opportunity with Opportunity Id and Name is now Closed Won.\n' + 
                                              'Opportunity Id: ' + opp.Id + '\n' +
                                              'Name: ' + opp.Name);
                mails.add(emailMessage);
            }
            // Send list of emails
            Messaging.sendEmail(mails);            
        }
    }

    public static void beforeDeleteMethod1(List<Opportunity> oppList)
    {
        Profile adminId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];

        for(Opportunity opp:oppList)
        {
            if(adminId != Sytem.UserInfo.getProfileId() && (opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost'))
            {
                opp.addError('Can\'t delete with System Admin Permissions');
            }
        }
        
    }

}
    

    

