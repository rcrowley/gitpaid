Git Paid, the programmer's time tracker
=======================================

Git Paid is a console time tracking program that stores work logs in Git.  Currently, it assumes begin and end commits are accurate in time and uses this to generate an invoice.  In the future, user-supplied billable hours will be supported.

See [`gpbegin`(1)](http://rcrowley.github.com/gitpaid/gpbegin.1.html), [`gpend`(1)](http://rcrowley.github.com/gitpaid/gpend.1.html), and [`gpinvoice`(1)](http://rcrowley.github.com/gitpaid/gpinvoice.1.html) for more details if this example isn't enough for you.

	$ gpbegin -b client-name
	$ ...
	$ gpend -b client-name -m "Shaved the yak."
	$ gpbegin -b client-name
	$ gpend -b client-name -t 1:45 -m "Faked the time."
	$ gpinvoice -b client-name
	# Invoice

	Thu Jan  6 18:27:32 UTC 2011
	from client-name branch of /home/vagrant/.gitpaid

	## Work log

	Began: Thu, 6 Jan 2011 16:17:29 +0000

	> Shaved the yak.

	Ended: Thu, 6 Jan 2011 17:47:42 +0000
	Billed time: 1:30

	Began: Thu, 6 Jan 2011 18:27:23 +0000

	> Faked the time.

	Ended: Thu, 6 Jan 2011 18:27:25 +0000
	Billed time (adjusted): 1:45

	## Summary

	Total billed time: 3:15
