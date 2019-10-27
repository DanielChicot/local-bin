#!/usr/bin/perl


while (<>) {
    chomp;
    if (/^\d{2}\/\d{2}\/\d{4}/) {
        my @data = split /,/;
        my @pertinent = ($data[0], $data[1], $data[4], $data[5]);
        print join(",", @pertinent), "\n";
    }
}
