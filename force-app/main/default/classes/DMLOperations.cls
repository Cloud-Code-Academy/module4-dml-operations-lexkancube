/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Michael Ncube
 */


//public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public class AccountManager {
        // Method to insert a new account and return its Id
    public static Id insertNewAccount() {
        // Create a new Account instance
        Account newAccount = new Account();

        // Set some fields on the Account
        newAccount.Name = 'Michael Code Co';

        // Insert the Account into the database
        insert newAccount;

        // Return the Id of the newly created Account
        return newAccount.Id;
        }
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        // Create a new Account and set the fields inline
        Account newAccount = new Account(
            Name = name,
            Industry = industry
        );

        // Insert the Account
        insert newAccount;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        // Create a new Contact instance
        Contact newContact = new Contact();
        
        // Set some fields on the Contact
        newContact.FirstName = 'Sarah';
        newContact.LastName = 'Connor';
        // Set the AccountId field to the given accountId
        newContact.AccountId = accountId;

        // Insert the Contact into the database
        insert newContact;

        // Return the Id of the newly created Contact
        return newContact.Id;
    }


    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        // Retrieve the Contact from the database
        // [SELECT Id FROM Contact WHERE Id = :contactId]
        Contact contactToUpdate = [SELECT Id FROM Contact WHERE Id = :contactId];

        // Update the Contact's last name
        contactToUpdate.LastName = newLastName;

        // Update the Contact in the database
        
        update contactToUpdate;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {
        // Retrieve the Opportunity from the database
        // [SELECT Id FROM Opportunity WHERE Id = :oppId]
        Opportunity oppToUpdate = [SELECT Id FROM Opportunity WHERE Id = :oppId];

        // Update the Opportunity's stage
        oppToUpdate.StageName = newStage;
    
        // Update the Opportunity in the database
        
        update oppToUpdate;
    }


    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        // Query the account
        // [SELECT Id FROM Account WHERE Id = :accountId]
        
        Account accountToUpdate = [SELECT Id FROM Account WHERE Id = :accountId];

        // Update the Account's Name and Industry
        accountToUpdate.Name = newName;
        accountToUpdate.Industry = newIndustry;

        // Update the Account with the given Id with the new name and industry
        
        update accountToUpdate;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        // Loop through each Opportunity in the list
        for (Opportunity opportunity : opportunities) {
            
                // Set the Opportunity's Stage to Qualification
                opportunity.StageName = 'Qualification';

                // Set the Opportunity's Close Date to 3 months from today   
                opportunity.CloseDate = Date.today().addMonths(3);

                // Set the Opportunity's Amount to 50000
                opportunity.Amount = 50000;
            }
        // Upsert the opportunities List so that records are either updated or created
        upsert Opportunities;
    }

    /**
     * Question 8
     * Insert or updates opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help with this.
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {   
        Account account;
    List<Account> existingAccounts = [SELECT Id FROM Account WHERE Name = :accountName ];
    
    if (existingAccounts.isEmpty()) {
        account = new Account(Name = accountName);
        insert account;
        } else {
        account = existingAccounts[0]; 
        
        }
        // Loop through each Opportunity name in the list
            // Create an Opportunity with the given name
            // Add the Opportunity to the list
            List<Opportunity> opportunities = new List<Opportunity>();
    for (String oppName : oppNames) {
        Opportunity opp = new Opportunity();
        opp.Name = oppName;
        opp.AccountId = account.Id;
        opp.StageName = 'Prospecting'; // Set a default StageName, modify as needed
        opp.CloseDate = Date.today().addMonths(1); // Set a default CloseDate, modify as needed
        opportunities.add(opp);
        }
    upsert Opportunities;
    }
    
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		// Query for the Account
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];

		// Create an Account variable to hold the upserted Account
        Account account;

    if (!accounts.isEmpty()) {
        // If the Account exists, update the description
        account = accounts[0];
        account.Description = 'Updated Account';
        } else {   
        // If the Account does not exist, create a new Account and set the description
        account = new Account(
        Name = accountName,
        Description = 'New Account'
        );
    }
       // Upsert the Account
        upsert account;

       // Return the upserted Account
        return account;
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
		// Loop through each Contact
    
		 // Create a map to store Account Name to Account Id
        Map<String, Account> accountMap = new Map<String, Account>();

         // Collect all unique account names from the contacts
        Set<String> accountNames = new Set<String>();
        for (Contact contact : contactsToUpsert) {
            accountNames.add(contact.LastName);
        }
    
         // Query existing accounts with these names
        List<Account> existingAccounts = [SELECT Id, Name FROM Account WHERE Name IN :accountNames];
        for (Account acc : existingAccounts) {
        accountMap.put(acc.Name, acc);
        }
    
         // List to hold new accounts to be inserted
        List<Account> accountsToInsert = new List<Account>();
    
         // Loop through each contact to create missing accounts and link them
        for (Contact contact : contactsToUpsert) {
            String accountName = contact.LastName;
            if (!accountMap.containsKey(accountName)) {
                 // Account does not exist, create a new one
                Account newAccount = new Account(Name = accountName);
                accountsToInsert.add(newAccount);
                 accountMap.put(accountName, newAccount); // Add the new account to the map
            }
             // Associate the contact with the account
            contact.AccountId = accountMap.get(accountName).Id;
        }
    
         // Insert the new accounts
        if (!accountsToInsert.isEmpty()) {
            upsert accountsToInsert;
             // Update the accountMap with the newly created account IDs
            for (Account acc : accountsToInsert) {
                accountMap.put(acc.Name, acc);
            }
    
             // Update the contacts with the new Account IDs
            for (Contact contact : contactsToUpsert) {
                String accountName = contact.LastName;
                contact.AccountId = accountMap.get(accountName).Id;
            }
        }
    
         // Upsert the contacts
        upsert contactsToUpsert;
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        // Create a list to hold Lead records
        List<Lead> leadsToInsert = new List<Lead>();

        // Loop through each Lead name and create a Lead record
        for (String leadName : leadNames) {
            Lead lead = new Lead(LastName = leadName, Company = 'Michael Cloud');
            leadsToInsert.add(lead);
        }
        
        // Insert the Leads
        try {
            insert leadsToInsert;
            System.debug('Leads Inserted: ' + leadsToInsert);

            // Collect the Ids of inserted Leads for deletion
        List<Id> leadIdsToDelete = new List<Id>();
        for (Lead insertedLead : leadsToInsert) {
            leadIdsToDelete.add(insertedLead.Id);
            }

          // Delete the Leads
        delete leadIdsToDelete;
        System.debug('Leads deleted: ' + leadIdsToDelete);
        }catch (DmlException e) {
            System.debug('Error inserting or deleting Leads: ' + e.getMessage());
        }
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
         // List to hold the Case records
        List<Case> caseList = new List<case>();
        
        // Create the specified number of cases
        for (Integer i = 0; i < numOfCases; i++) {
            Case caseToInsert = new Case(AccountId = accountId, Subject = 'Case ' + i);
            
            caseList.add(caseToInsert);
        }
        
        // Insert the cases
        if (!caseList.isEmpty()) {
            insert caseList;
        }
        
        // Delete the cases
        if (!caseList.isEmpty()) {
            delete caseList;
        }
    }
