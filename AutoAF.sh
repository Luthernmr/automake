# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

if [ "$1" == "install" ]; then
	cp AutoAF.sh ~/
	echo "alias automake=\"bash ~/AutoAF.sh\"" >> ~/.zshrc
	printf "${BRed}Tu peux maintenant utiliser la commande : ${BWhite}automake [PARAM]\n"
	printf "${BPurple}RAPPEL:\n"
	printf "${BCyan}Initialiser le workspace: ${BWhite}automake [init]\n"
	printf "${BCyan}Lancer le programme : ${BWhite}automake [NOM DU PROGRAME]\n"	 
	exit
elif [ "$1" == "" ]; then
	printf "${BRed}Donnez un nom au programme "
	exit
elif [ "$1" == "init" ]; then
	mkdir srcs
	mkdir includes
	touch main.cpp
	printf "${BRed}Les repertoire ont bien ete cree"
	exit
fi

while true
do
sleep 1
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
done
