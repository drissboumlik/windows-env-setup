

rem =============================================================
rem = OTHER ALIASES
rem =============================================================
cdd=cd /d $*
-cd=cd - $*
lsa=ls -a --show-control-chars -F --color $*
lsall=ls -latsh $*
quit=exit
:q=exit
exp=explorer $*
e=explorer $*
rmrf=rm -rf $*
bzsh=bash -c zsh
bsh=C:\Cmder\vendor\conemu-maximus5\..\git-for-windows\bin\bash $*
a:r=alias /reload
env:r=RefreshEnv.cmd
w:env=%windir%\System32\SystemPropertiesAdvanced.exe


rem =============================================================
rem = PLUGINS
rem =============================================================
aliasf=alias | fzf $*
z=zoxide query $*
zi=zoxide query --interactive $*
z+=zoxide add $*
z-=zoxide remove $*
z*=zoxide edit $*
zi=z -I $*
lss=eza $2 --tree --level=$1 --icons=always 


rem =============================================================
rem = GIT
rem =============================================================
gs=git status $*
ga=git add $*
ga.=git add .
gaa=git add . $*
gsh=git show $*
glg=git log $*
glp=git log-pretty $*
glp2=git log-pretty2 $*
glp3=git log-pretty3 $*
glf=git log-pretty | tail -n $*
gll=git log-pretty -n $*
gl=git log --oneline --all --graph --decorate  $*
gc=git commit $*
gd=git diff $*
gcm=git commit -m "$*"
gcmall=git add . && git commit -m "$*"
wip=git add . && git commit -m "$* (wip)"  
gpl=git pull $*
gps=git push $*
gplgit=git pull github master $*
gpsbit=git push bitbucket master $*
gpsgit=git push github master $*
grv=git remote -v $*
gplbit=git pull bitbucket master $*
gplom=git pull origin master $*
gpsom=git push origin master $*
gi=git init $*
gck=git checkout $*
gckpl=git checkout $2 && git pull $1 $2
gckr=git checkout $1/$2 && git checkout -b $2
gckp=git checkout @{-$*}
gm=git merge $*
gb=git branch $*
gcl=git clone $*
grfl=git reflog $*
gplo=git pull origin $*
gpso=git push origin $*
gr=git reset $*
grh=git reset --hard $*
nah=git reset --hard && git clean -df
grhh=git reset --hard HEAD $*
grs=git reset --soft $*
grm=git rm $*
gmg=git merge $*  


rem =============================================================
rem = NPM
rem =============================================================
nu=npm update $*
ni=npm install $*
nrs=npm run serve $*
nrd=npm run dev $*
nrb=npm run build $*
nrw=npm run watch $*
nrp=npm run prod $*
nv=nvm current  
ncc=npm cache clean --force $* && npm cache verify --force $*


rem =============================================================
rem = ENV
rem =============================================================


rem =============================================================
rem = COMPOSER
rem =============================================================
ci=composer install $*
cu=composer update $*
cmpref=composer dump-autoload $*
ci1=composer1 install $*
cu1=composer1 update $*
cmpref1=composer1 dump-autoload $*


rem =============================================================
rem = PHP
rem =============================================================
phpstan=.\vendor\bin\phpstan $*
rector=.\vendor\bin\rector $*
psalm=.\vendor\bin\psalm $*
pint=.\vendor\bin\pint $*
phpserve=php -S localhost:$1 -t $2


rem =============================================================
rem = LARAVEL
rem =============================================================
pamk=php artisan make:$*
pav=php artisan --version $*
pam=php artisan migrate $*
pas=php artisan serve $*
pa=php artisan $*
pamfs=php artisan migrate:fresh --seed $*
pamfspi=php artisan migrate:fresh --seed && php artisan passport:install --force $*
parl=php artisan route:list $*
pamf=php artisan migrate:fresh $*
pamkmm=php artisan make:model $1 -m
pamkmmc=php artisan make:model $1 -m -c
pamkmmcr=php artisan make:model $1 -m -c -r
pash=php artisan serve --host $*
pasp=php artisan serve --port $*
pasph=php artisan serve --port $1 --host $2
pashp=php artisan serve --host $1 --port $2
pamkmdl=php artisan make:model $*
pamkc=php artisan make:controller $*Controller
pamkmg=php artisan make:migration create_$*_table
pamkcr=php artisan make:controller $*Controller -r
pams=php artisan migrate --seed $*
pamkr=php artisan make:resource $*Resource
pamkrc=php artisan make:resource $*Collection
pamkrq=php artisan make:request $*Request
pamkf=php artisan make:factory $1Factory --model=$1
pamkfm=php artisan make:factory $1Factory --model=$2
pat=php artisan tinker $*
padbs=php artisan db:seed $*
pamks=php artisan make:seeder $1sSeeder
pamkfsd=php artisan make:factory $1Factory --model=$1 && php artisan make:seeder $1sSeeder
pakg=php artisan key:generate $*
pamkcmp=php artisan make:component $*
pamkall=php artisan make:model $1 -m -c -f && php artisan make:seeder $1sSeeder
pamkallmdl=php artisan make:model $1/$2 -m -c -f && php artisan make:seeder $2sSeeder
pamkallmdlsd=php artisan make:model $1/$2 -m -c -f && php artisan make:seeder $3sSeeder
pamkallsd=php artisan make:model $1 -m -c -f && php artisan make:seeder $2sSeeder
clearall=php artisan optimize && php artisan cache:clear && php artisan view:clear && php artisan config:clear
rfl=composer dumpautoload && php artisan optimize && php artisan view:clear && php artisan cache:clear && php artisan config:clear 
rfl1=composer1 dumpautoload && php artisan cache:clear && php artisan view:clear && php artisan config:clear && php artisan route:clear  
pamkallr=php artisan make:model $1 -m -c -f && php artisan make:seeder $1sSeeder && php artisan make:resource $1Resource
rld=git pull origin master && composer dumpautoload && php artisan optimize && php artisan cache:clear && php artisan view:clear && npm run dev $*
rld1=git pull origin master && composer1 dumpautoload && php artisan optimize && php artisan cache:clear && php artisan view:clear && npm run dev $*
pamkj=php artisan make:job $*Job
pamke=php artisan make:event $*Event
parc=php artisan route:clear  
pavc=php artisan view:clear  
pacc=php artisan cache:clear  
pacgc=php artisan config:clear  
pacgcc=php artisan config:cache  
pao=php artisan optimize  
pasl=php artisan storage:link  


rem =============================================================
rem = DOCKER
rem =============================================================
dk=docker $*
dkps=docker ps $*
dkpsa=docker ps -a $*
dkll=docker kill $*
dkrmcn=docker container rm $*
dkrmim=docker image rm $*
dkimls=docker image ls $*
dksp=docker system prune $*
dkspa=docker system prune -a $*
dkim=docker image $*
dkims=docker images $*
dkimsa=docker images -a $*
dc=docker-compose $*
dcx=docker-compose exec $*  
dcxpunit=docker-compose exec $1 ./vendor/bin/phpunit $2  
dcxpest=docker-compose exec $1 ./vendor/bin/pest $2  
dcxpatest=docker-compose exec $1 php artisan test $2  


rem =============================================================
rem = EXE
rem =============================================================


rem =============================================================
rem = CD..
rem =============================================================
.ssh=cd "%USERPROFILE%\.ssh\" && C:  
home=cd "%USERPROFILE%\" && C:


rem =============================================================
rem = SSH
rem =============================================================


rem =============================================================
rem = SCRIPTS
rem =============================================================
