//3 ways to execute shell
1: bash file_name || sh file_name (recommended)
	//if no permission to execute, use this
	//
2: ./file_name
	//this way can only use if permission gained. file is executable
	
3: source file_name || . file_name
	//can link the operated variable to be valid in the current termial
	//e.g path='pwd', other 2 executing way wont make current termial find the 
	//variable path, but use 'source' or '. ' will.
	//CHANGED VAIABLE WILL BE STORED IN THE CURRENT TERMINAL















