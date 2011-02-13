//
// SFHFEditableCell.m
//
// Created by Buzz Andersen on 12/3/08.
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
//

#import "SFHFEditableCell.h"

@implementation SFHFEditableCell

@synthesize textField = m_textField;
@synthesize label = m_label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        m_label = [[UILabel alloc] initWithFrame: CGRectZero];
        m_label.font = [UIFont boldSystemFontOfSize: 16.0];
        m_label.textColor = [UIColor darkTextColor];
        [self addSubview: m_label];
        
        m_textField = [[UITextField alloc] initWithFrame:CGRectZero];
        m_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_textField.font = [UIFont systemFontOfSize:16.0];
        m_textField.textColor = [UIColor darkTextColor];
        m_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview: m_textField];
        
        self.textField.clearButtonMode = UITextFieldViewModeNever;
        self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    
    return self;
}

- (void)layoutSubviews {
	[self.label sizeToFit];
	self.label.frame = CGRectMake(self.contentView.bounds.origin.x + 20, self.contentView.bounds.origin.y + 11, self.label.frame.size.width, self.label.frame.size.height);
	
    self.textField.frame = CGRectMake(self.label.frame.origin.x + self.label.frame.size.width + self.label.frame.origin.x + 8, self.contentView.frame.origin.y, self.contentView.frame.size.width - self.label.frame.size.width - self.label.frame.origin.x - 20 - 8, self.contentView.frame.size.height - 2);
    
    [super layoutSubviews];
}

- (void)setLabelText: (NSString *)labelText andPlaceholderText: (NSString *)placeholderText {
	self.label.text = labelText;
	
	self.textField.placeholder = placeholderText;
	
	[self layoutSubviews];
}

- (void)setTextFieldAsPassword {
    self.textField.clearButtonMode = UITextFieldViewModeNever;
    [self.textField setSecureTextEntry:YES];
}

- (void) dealloc {
    [m_textField release];
	[m_label release];
    [super dealloc];
}


@end
