//
//  TJLocationNameCell.m
//  TuiJi_T.B.E
//
//  Created by TuiJi on 2016/10/21.
//  Copyright © 2016年 TUIJI. All rights reserved.
//

#import "TJLocationNameCell.h"
#import "TJLocationName.h"

@interface TJLocationNameCell ()

@property (weak, nonatomic) IBOutlet UILabel *locationNameView;
@property (weak, nonatomic) IBOutlet UILabel *locationDistantView;
@property (weak, nonatomic) IBOutlet UILabel *locationDetailView;


@end

@implementation TJLocationNameCell

- (void)setLocationName:(TJLocationName *)locationName{
    _locationName = locationName;
    
    _locationNameView.text = _locationName.locationName;
    _locationDistantView.text = _locationName.locationDistant;
    _locationDetailView.text = _locationName.locationDetail;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"cell";
    TJLocationNameCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TJLocationNameCell" owner:nil options:nil] firstObject];
    }

    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
