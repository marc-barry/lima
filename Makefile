.PHONY: env machine-start machine-stop machine-delete machine-shell

env:
	./env.sh

machine-start:
	source ./env.sh && ./start.sh

machine-stop:
	source ./env.sh && ./stop.sh

machine-delete:
	source ./env.sh && ./delete.sh

machine-shell:
	source ./env.sh && ./shell.sh

