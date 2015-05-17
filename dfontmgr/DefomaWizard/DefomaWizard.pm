#!/usr/bin/perl -w
#
# This is the basis of an application with signal handlers
#
# You can safely edit this file, any changes that you make will be preserved
# and this file will not be overwritten by the next run of Glade::PerlGenerate
#
# Skeleton subs of any missing signal handlers can be copied from
# /home/redstar/Projects/defomawizard/src/DefomaWizardSIGS.pm
#
#==============================================================================
#=== This is the 'defomawizard' class                              
#==============================================================================
package defomawizard;
require 5.000; use strict 'vars', 'refs', 'subs';
# UI class 'defomawizard' (version 0.01)
# 
# Copyright (c) Date 2001年 11月 16日 金曜日 22:44:05 JST
# Author Yasuhiro Take,,, <redstar\@laminar>
#
## Unspecified copying policy, please contact the author\n#  Yasuhiro Take,,, <redstar\@laminar>
#
#==============================================================================
# This perl source file was automatically generated by 
# Glade::PerlGenerate version 0.59 - Wed Jun 20 14:48:25 BST 2001
# Copyright (c) Author Dermot Musgrove <dermot.musgrove\@virgin.net>
#
# from Glade file /home/redstar/Projects/defomawizard/defomawizard.glade
# 2001年 11月 16日 金曜日 22:44:05 JST
#==============================================================================

BEGIN {
    use DefomaWizardUI;
} # End of sub BEGIN

my $Modal;
my $TimeoutTag;
my $TimeoutFunc;
my $Width = 480;
my $Height = 320;
my $Window;
my $YesNo;
my @ClistM;
my $ClistS;
my $Cancel = 0;

sub update_text {
    my $text = shift;
    
    my $w = $Window->{text};

    $w->freeze();

    $w->set_point(0);
    $w->forward_delete($w->get_length());

    $w->insert(undef, undef, undef, $text);

    $w->thaw();
}

sub init_note {
    return;
}

sub init_yesno {
    $Window->{yesnobox}->show();
    $Window->{radiobutton_yes}->clicked();
}

sub init_singlelist {
    my %op = @_;

    $Window->{listbox}->show();
    $Window->{clist}->set_selection_mode('browse');
    
    $Window->{clist}->freeze();
    $Window->{clist}->clear();
    
    @ClistM = ();
    $ClistS = -1;

    my $items = $op{items};
    
    foreach my $l (@{$items}) {
	$Window->{clist}->append($l);
    }

    $Window->{clist}->thaw();

    if (exists($op{preselect})) {
	$Window->{clist}->select_row($op{preselect}, -1);
    }
}

sub init_multilist {
    my %op = @_;
    
    $Window->{listbox}->show();
    $Window->{clist}->set_selection_mode('multiple');
    
    $Window->{clist}->freeze();
    $Window->{clist}->clear();
    
    @ClistM = ();
    $ClistS = -1;

    my $items = $op{items};

    foreach my $l (@{$items}) {
	$Window->{clist}->append($l);
	push(@ClistM, 0);
    }

    $Window->{clist}->thaw();
	    
    my $onoff = $op{onoff};

    if ($onoff) {
	for (my $i = 0; $i < @{$onoff}; $i++) {
	    if ($onoff->[$i]) {
		$Window->{clist}->select_row($i, -1);
	    }
	}
    }
}

sub init_entry {
    my %op = @_;
    
    $Window->{entry}->show();

    my $pretext = $op{pretext};

    $Window->{entry}->set_text(defined($pretext) ? $pretext : '');
}

sub init_text {
    my %op = @_;

    $Window->{textbox}->show();

    my $pretext = $op{pretext};
    my $preposition = $op{preposition};

    my $w = $Window->{textarea};

    $w->freeze();

    $w->set_point(0);
    $w->forward_delete($w->get_length());

    $w->insert(undef, undef, undef, $pretext) if (defined($pretext));

    $w->thaw();

    $w->set_position($preposition) if (defined($preposition));
}

sub term_note {
    return 0;
}

sub term_yesno {
    return $YesNo;
}

sub term_singlelist {
    return $ClistS;
}

sub term_multilist {
    return @ClistM;
}

sub term_entry {
    my $ent = $Window->{entry}->get_text();
    return $ent;
}

sub term_text {
    my $w = $Window->{textarea};
    $w->freeze();
    $w->set_position(0);
    return $w->get_chars(0, $w->get_length());
}

sub set_default_size {
    $Width = shift;
    $Height = shift;
}

# run(type => 'note', title => "...", text => "...");
# run(type => 'yesno', title => "...", text => "...");
# run(type => 'singlelist', title => "...", text => "...", items => \@items,
#     preselect => n);
# run(type => 'multilist', title => "...", text => "...", items => \@items,
#     onoff => \@onoff);
# run(type => 'entry', title => "...", text => "...", pretext => "...");
# run(type => 'text', title => "...", text => "...", pretext => "...",
#     prevadj => -double-);

sub main {
    my %op = @_;

    $Cancel = 0;
    my $com = $op{type};
    my $text = $op{text};
    my $title = $op{title};
    my $window;

    unless ($Window) {
	$window = defomawizard->new;
	$Window = $window->{FORM};
	$Window->{defomawizard}->set_usize($Width, $Height);
	$Window->{defomawizard}->set_modal($Modal) if (defined($Modal));
	$Window->{textarea}->set_word_wrap(1);
	$Window->{text}->set_word_wrap(1);
	$window->TOPLEVEL->show;
    }
    
    update_text($text);
    $Window->{label1}->set($title);

    $Window->{listbox}->hide();
    $Window->{entry}->hide();
    $Window->{yesnobox}->hide();
    $Window->{textbox}->hide();

    eval("init_$com(%op)");

    $TimeoutTag = Gtk->timeout_add(100, $TimeoutFunc) if ($TimeoutFunc);
    Gtk->main;

    if ($TimeoutTag) {
	Gtk->timeout_remove($TimeoutTag);
	undef $TimeoutTag;
    }

    if ($Cancel == 255) {
	$Window->{defomawizard}->destroy();
	undef $Window;
    }

    return wantarray ? () : undef if ($Cancel);

    return eval("term_$com(%op)");
}

sub get_status {
    return $Cancel;
}

sub set_timeout {
    $TimeoutFunc = shift;
}

sub set_modal {
    $Modal = shift;
}

sub destroy {
    if ($Window) {
	$Window->{defomawizard}->destroy();
	undef $Window;
    }
}

sub get_window {
    return $Window;
}

#===============================================================================
#=== Below are the default signal handlers for 'defomawizard' class
#===============================================================================
sub about_Form {
    my ($class) = @_;
    my $gtkversion = 
        Gtk->major_version.".".
        Gtk->minor_version.".".
        Gtk->micro_version;
    my $name = $0;
    my $message = 
        __PACKAGE__." ("._("version")." $VERSION - $DATE)\n".
        _("Written by")." $AUTHOR \n\n".
        _("No description")." \n\n".
        "Gtk ".     _("version").": $gtkversion\n".
        "Gtk-Perl "._("version").": $Gtk::VERSION\n".
        _("run from file").": $name";
    __PACKAGE__->message_box($message, _("About")." \u".__PACKAGE__, [_('Dismiss'), _('Quit Program')], 1,
        "$Glade::PerlRun::pixmaps_directory/glade2perl_logo.xpm", 'left' );
} # End of sub about_Form

sub destroy_Form {
    my ($class, $data, $object, $instance) = @_;
    Gtk->main_quit; 
} # End of sub destroy_Form

sub toplevel_hide    { shift->get_toplevel->hide    }
sub toplevel_close   { shift->get_toplevel->close   }
sub toplevel_destroy { shift->get_toplevel->destroy }

#==============================================================================
#=== Below are the signal handlers for 'defomawizard' class 
#==============================================================================
sub on_clist_select_row {
    my ($class, $data, $object, $instance, $row) = @_;
    $ClistM[$row] = 1;
    $ClistS = $row;
}

sub on_clist_unselect_row {
    my ($class, $data, $object, $instance, $row) = @_;
    $ClistM[$row] = 0;
    $ClistS = -1;
}

sub on_radiobutton_no_clicked {
    my ($class, $data, $object, $instance, $event) = @_;
    $YesNo = 'no';
}

sub on_radiobutton_yes_clicked {
    my ($class, $data, $object, $instance, $event) = @_;
    $YesNo = 'yes';
}

sub on_cancel_clicked {
    $Cancel = 1;
    Gtk->main_quit;
}

sub on_defomawizard_delete_event {
    $Cancel = 255;
    Gtk->main_quit;
    return 0;
}

sub on_entry_activate {
    Gtk->main_quit;
}

sub on_next_clicked {
    Gtk->main_quit;
}




1;

__END__

#===============================================================================
#==== Documentation
#===============================================================================
=pod

=head1 NAME

DefomaWizard - version 0.01 2001年 11月 16日 金曜日 22:44:05 JST

No description

=head1 SYNOPSIS

 use DefomaWizard;

 To construct the window object and show it call
 
 Gtk->init;
 my $window = defomawizard->new;
 $window->TOPLEVEL->show;
 Gtk->main;
 
 OR use the shorthand for the above calls
 
 defomawizard->app_run;

=head1 DESCRIPTION

Unfortunately, the author has not yet written any documentation :-(

=head1 AUTHOR

Yasuhiro Take,,, <redstar\@laminar>

=cut
