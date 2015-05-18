LIBS = str
DEPS = 
 
LFLAGS = -libs $(LIBS)
CFLAGS = -Is $(DEPS)
  
wapp:
	corebuild -pkgs sqlite3,opium,cow -pkg cow.syntax wapp.native
			 
clean:
	rm -rf _build/ *.native *.byte
			                
