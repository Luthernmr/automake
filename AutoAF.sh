if [ "$1" == "" ]; then
	printf "Donnez un nom au programme "
elif [ "$1" == "init" ]; then
	mkdir srcs
	mkdir includes
	touch main.cpp
	exit
fi
ls srcs | grep .cpp > cppfiles
ls | grep .cpp > cppfiles
ls includes | grep .hpp > hppfiles

echo "CC = c++

CC_FLAGS = -Wall -Werror -Wextra

NAME := $1
" > Makefile

a=0
while read line
do
	if [ "$a" == "0" ]; then 
		echo "SRCS := $line \\" >> Makefile
	else
		echo "		$line \\" >> Makefile
	fi
	a=(a+1)
done < cppfiles
if [ "$a" == "0" ]; then 
		echo "SRCS := " >> Makefile
fi
echo '
OBJS := $(SRCS:.cpp=.o)

all : $(NAME)

$(NAME):		$(addprefix objs/, $(OBJS)) Makefile
				$(CC) $(CC_FLAGS) -o $(NAME) $(addprefix objs/, $(OBJS))' >> Makefile
a=0
echo -n 'objs/%.o:		%.cpp Makefile' >> Makefile
while read line
do
	echo -n " includes/$line" >> Makefile
	a=(a+1)
done < hppfiles	

echo '
				@mkdir -p objs
					$(CC) $(CC_FLAGS) -c $< -o "$@"
		
clean :
		rm -rf objs

fclean : clean
		rm -f $(NAME)

re : fclean all

.PHONY : re clean fclean all .PHONY'>> Makefile

rm -rf cppfiles
rm -rf hppfiles
