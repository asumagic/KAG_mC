namespace mc
{
	string getMan(string command)
	{
		syncGetDocs();

		string docget;
		if (!docs.get(command, docget))
		{
			return "This command either does not exists either have not registered a manual entry.";
		}
		return docget;
	}

	dictionary docs; // Using this we can bind command names to commands, since all of those doesn't obviously use them.

	void syncSetDocs()
	{
		getRules().set("mc_docs", docs);
	}

	void syncGetDocs()
	{
		getRules().get("mc_docs", docs);
	}

	void registerDoc(string name, string doc)
	{
		syncGetDocs();

		print("Registering command manual '" + name + "'...");

		docs.set(name, doc);

		syncSetDocs();
	}

}