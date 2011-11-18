# THMultiPartLabel README #

## What is THMultiPartLabel? ##

As of iOS 5.0.1, there's currently no way (that I know of) to display a line of formatted text with multiple styles in a single UILabel.  In other words, you can have:

Hello, World!

or

**Hello, World!**

but not

Hello, **World**!

THMultiPartLabel attempts to provide a simple workaround to this problem by encapsulating multiple auto-sized UILabel subviews under a single object.  Each UILabel can then be assigned particular parameters (font, colour, alignment, etc.).  When drawn, each label will be drawn sequentially, from left to right, according to its individual specifications.

I put this class together because I was looking for a way to emulate Apple's built-in contact list functionality, which presents contacts' names in the form of "Firstname **Lastname**".  After a great deal of googling, I stumbled upon Jason Miller's [excellent Stack Overflow answer](http://stackoverflow.com/questions/1417346/iphone-uilabel-containing-text-with-multiple-fonts-at-the-same-time/1532634#1532634), upon which this class is based.

His code, with a few modifications, allowed me to implement my contact list the way I wanted, so I'm putting it up on GitHub in the hopes that someone else will find it as useful as I did.

## Installation ##

Just copy the .h and .m files into your project somewhere and make sure you add them in Xcode.

**Note: this class is designed for ARC.** If you're not using ARC in your project, be sure to add the `-fobjc-arc` flag to the THMultiPartLabel.m line of the "Compile Sources" section under your target's Build Phases.  If you aren't using LLVM 3.0 at all, you'll have to add all of the memory management shenanigans yourself.

## Usage ##

For my project, I wanted a list of contacts with last names in bold, so I added a UITableViewDelegate to my view controller and configured the cells like so:

```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		
		cell.textLabel.text = @" "; // we're not going to use the built-in label
		
		UIFont *firstNameFont = [UIFont systemFontOfSize:20];
		UIFont *lastNameFont = [UIFont boldSystemFontOfSize:20];
		NSArray *fonts = [NSArray arrayWithObjects: firstNameFont, lastNameFont, nil];
		THMultiPartLabel *mpLabel = [[THMultiPartLabel alloc] initWithOffsetX:44 Y:2 defaultFonts:fonts];
		[cell addSubview:mpLabel];
	}
	
	// get our pre-allocated multi-part label from the current cell
	THMultiPartLabel *mpLabel = [cell.subviews objectAtIndex:1];
	[mpLabel updateText:@"Tom", @"Heinan", nil];
	
	cell.detailTextLabel.text = @"some informative text";
	cell.imageView.image = [UIImage imageNamed:@"contact"];
	
	return cell;
}
```

The above code should get you something similar to this:

![THMultiPartLabel example](http://files.tomheinan.com/images/thmpl-row.png)

## Changelog ##

-	1.0.1: initial release.
