name=main_transform

transform:
	if [ -d "./build" ]; then rm -r build; fi
	mkdir build
	
	# from cuda documentation
	nvcc -c -I/usr/local/cuda/include  -I../spinta $(name).cu -o ./build/nvcc_$(name).o
	g++ -o ./build/$(name).out ./build/nvcc_$(name).o -L/usr/local/cuda/lib64 -lcusparse -lcudart

	echo "\nCompiled\n -- Starting program --"
	./build/*.out

for_each:
	if [ -d "./build" ]; then rm -r build; fi
	mkdir build
	
	# from cuda documentation
	nvcc -c -I/usr/local/cuda/include  -I../spinta main_for_each.cu -o ./build/nvcc_for_each.o
	g++ -o ./build/for_each.out ./build/nvcc_for_each.o -L/usr/local/cuda/lib64 -lcusparse -lcudart

	echo "\nCompiled\n -- Starting program --"
	./build/for_each.out

count:
	if [ -d "./build" ]; then rm -r build; fi
	mkdir build
	
	# from cuda documentation
	nvcc -c -I/usr/local/cuda/include  -I../spinta main_count.cu -o ./build/nvcc_count.o
	g++ -o ./build/count.out ./build/nvcc_count.o -L/usr/local/cuda/lib64 -lcusparse -lcudart

	echo "\nCompiled\n -- Starting program --"
	./build/count.out

