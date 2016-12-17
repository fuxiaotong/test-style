#!/usr/bin/perl
use strict;
use warnings;
use Term::ANSIColor;

sub Message(@);
sub CommonMessage(@);

my ($infile, $lineno, $line, $line_1, $line_2, $line_3);
my $line_end = 0;
my $count = 0;
our $err = 0;

for my $file (@ARGV) {
    $infile = $file;

    open my $in, $infile or die $!;
    print "checking $infile...\n";
    $lineno = 0;

    my $level = 0;

    while (<$in>){
		$line = $_;

		$lineno++;

        # detect the commentary. BTW "\S" will match the symbol '-' which is the last character of "--".
        if($line =~ /.*(\s*)(-(?=-))(\S?)(\s*).*/){
            if(length($4) != 1){
                Message("-> NO.$lineno: code >>> ",
                    "$line",
                    " annotate style error:it should place a space after --\n"
                    );
            }
            my @arr_spl = split(/--/, $line);  # split the string and put the string before "--" into $line.
            $line = $arr_spl[0];
            # print($line)
        }

        # 检查逗号左边是否有0个空格，右边是否有1个空格
        if($line =~ /\(.+( *),( *).+\)/){
            if(length($1) != 0 || length($2) != 1 ){
                Message("-> NO.$lineno: code >>> ",
                    "$line",
                    " space error on both sides of the \",\" \n"
                    );
            }
        }

        # 检测 else 上面是否有一个空行
        if($line =~ /^function/){
            if($line_1 !~ /^\n/){
                Message("-> NO.$lineno: code >>> ",
                    "$line",
                    " it has no 2 blank line above function\n"
                    );

            }else{
                if($line_2 !~ /^\n/){
                    Message("-> NO.$lineno: code >>> ",
                        "$line",
                        " it has no 2 blank line above function\n"
                        );

                }else{
                    if($line_3 =~ /^\n/){
                        Message("-> NO.$lineno: code >>> ",
                            "$line",
                            " it has too many blank line above function\n"
                            );
                    }
                }
            }
        }

        # 检测 else 上面是否有一个空行
        if($line =~ /else/){
            if($line_1 !~ /^\n/){
                Message("-> NO.$lineno: code >>> ",
                    "$line",
                    " it has no blank line above else\n"
                    );

            }else{
                if($line_2 =~ /^\n/){
                    Message("-> NO.$lineno: code >>> ",
                        "$line",
                        " it has too many blank line\n"
                        );
                }
            }
        }

        # 检查（）的边缘是否有空格
        if($line =~ /\(( *).+( *)\)/){
            if(length($1) != 0 || length($2) != 0){
                Message("-> NO.$lineno: code >>> ",
                    "$line",
                    " there is extra space around the brackets\n"
                    );
            }        
        }

        #检测特殊符号左右两边有没有多余空格或没有空格
        if($line =~ /(\s*)(==|=|>=|<=|>|<|\+|\*|\/|_=|~=)(\s*)/){
            if(length($1) != 1 || length($3) != 1){
                # print "left: ".length($1).", right: ".length($2)."\n";
                Message("-> NO.$lineno: code >>> ",
                    "$line",
                    " space error on both sides of the special symbol \"$2\"\n"
                    );
            }        
        }


        #检测 - 号
        if($line =~ /.*(\s*)((?<!-)-(?!-))(\s*).*/){        
            if(length($1) != 1 && length($3) != 1){
                Message("-> NO.$lineno: code >>> ",
                    "$line",
                    " space error on both sides of the special symbol \"-\"\n"
                    );
            }        
        }

        #检测每行尾部有没有无效的空格
        if($line =~ /(\s+)[\r]?\n$/){
            Message("-> NO.$lineno: code >>> ",
                "$line",
                " found unnecessary tail space\n"
                );
        }

        # 检测每行字符是否超过80个字符
        if(length($line) > 80){
            Message("-> NO.$lineno: code >>> ",
                "$line",
                " this line too long exceed 80 characters\n"
                );
        }

        $line_3 = $line_2;
        $line_2 = $line_1;
        $line_1 = $line;
		
	}

}

if($err == 0){
    CommonMessage('green',"ALL SUCCESS\n");
}

sub Message(@){
    my($numline, $code, $messages) = @_;
    if($numline =~ />>>/){
        $err = 1;
    }
    print color "bold yellow";
    print "$numline";
    print color 'reset';

    print color "bold white";
    print "$code";
    print color 'reset';

    print color "bold red";
    print "Message: $messages\n";
    print color 'reset';

}

sub CommonMessage(@){
    my($colors,$messages) = @_;
    print color "bold $colors";
    print "$messages \n";
    print color 'reset';
}
