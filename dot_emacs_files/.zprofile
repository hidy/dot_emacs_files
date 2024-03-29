#
# $URL: file:///home/ryo/svn/zshconf/trunk/dot.zprofile $
# $Id: dot.zprofile 2 2006-02-27 16:31:19Z ryo $

echo "Loading $HOME/.zprofile"

### Select OS type

case $OSTYPE {
  sunos*)	export SYSTEM=sun ;;
  solaris*)	export SYSTEM=sol ;;
  irix*)	export SYSTEM=sgi ;;
  osf*)		export SYSTEM=dec ;;
  linux*)	export SYSTEM=gnu ;;
  freebsd*)	export SYSTEM=bsd ;;
  darwin*)	export SYSTEM=darwin ;;    # MacOSX
}

# ZDOTDIR は zsh の個人用設定ファイルを探すディレクトリを指定する

if [ -z $ZDOTDIR ]; then
  export ZDOTDIR=$HOME
fi

# 切り分けた設定ファイルを読み込むディレクトリを指定する

export ZUSERDIR=$ZDOTDIR/.zsh


### System specific environment

# 環境変数（PATH など）の OS 別設定ファイルを読み込む

if [ -f $ZUSERDIR/zshrc.$SYSTEM ]; then
  source $ZUSERDIR/zshrc.$SYSTEM
fi

# man path
export MANPATH="/usr/share/man:/usr/X11R6/man:/usr/local/man:/var/qmail/man:$HOME/man:."

# opencv path
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/opencv/lib/pkgconfig

### environment variables

# 共通する環境変数を設定する

#export LESSCHARSET=japanese-euc
export LESSCHARSET=japanese
#export LESS='-irqMM'
export LESS='-iqMM'
unset  LESSOPEN
export GZIP='-v9N'
export XMODIFIERS=@im=kinput2
#export XMODIFIERS=@im=_XWNMO
