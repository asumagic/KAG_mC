namespace mc
{
	string getMan(string command)
	{
		syncGetDocs();

		string docget;
		if (!docs.get(command, docget))
		{
			return "";
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

		string manentry = getMan(name);

		if (manentry == "")
		{
			print("Registering command manual '" + name + "'...");
		}
		else
		{
			if (manentry != doc)
			{
				print("Updating command manual '" + name + "'...");
			}
			else
			{
				return;
			}
		}

		docs.set(name, doc);

		syncSetDocs();
	}

}