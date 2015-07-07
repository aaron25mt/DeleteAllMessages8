#import <ChatKit/ChatKit.h>

%hook CKConversationListController
-(void)setEditing:(BOOL)arg1 animated:(BOOL)arg2 {
	%orig;
	if(arg1) {
		UIBarButtonItem* deleteAll = [[UIBarButtonItem alloc] initWithTitle:@"Delete All" style:UIBarButtonItemStyleDone target:self action:@selector(alert:)];
		self.navigationItem.rightBarButtonItem = deleteAll;
		[deleteAll release];
	} else {
		UIBarButtonItem* compose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeButtonClicked:)];
		self.navigationItem.rightBarButtonItem = compose;
		[compose release];
	}
}

%new
-(void)alert:(id)sender {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];
}

%new
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 1) {
		CKConversationList* list = MSHookIvar<CKConversationList*>(self, "_conversationList");
		UITableView* messages = MSHookIvar<UITableView*>(self, "_table");
		NSUInteger msgCount = [(NSArray*)[list conversations] count];
		while(msgCount > 0) {
			[list deleteConversation:[list conversations][0]];
			msgCount--;
		}
		[messages reloadData];
	}
	[self setEditing:NO animated:NO];
}
%end