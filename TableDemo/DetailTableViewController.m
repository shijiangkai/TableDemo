//
//  DetailTableViewController.m
//  
//
//  Created by 史江凯 on 15/5/12.
//
//

#import "DetailTableViewController.h"
#import <UIImageView+WebCache.h>
#import "XYZAbilityCell.h"
#import "XYZBioCell.h"

@interface DetailTableViewController ()
{
    NSString *dataPath;
}
//@property (strong, nonatomic) NSMutableDictionary *offscreenCells;
@property NSMutableDictionary *abilityList;
@property NSString *heroBio;
@property (weak, nonatomic) IBOutlet UIImageView *heroImageView;

@end

@implementation DetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.heroImageView sd_setImageWithURL:self.fullImageURL];
//    self.offscreenCells = [NSMutableDictionary dictionary];
    
    //iOS8里这两行代码可以代替tableView:heightForRowAtIndexPath:（打开这两行，关闭tableView:heightForRowAtIndexPath:）
//    self.tableView.estimatedRowHeight = 100;//100主要是为了abilityCell的高度
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSDictionary *heroDetail = [NSDictionary dictionaryWithContentsOfFile:[dataPath stringByAppendingPathComponent:@"Detaildata.plist"]];
    self.heroBio = heroDetail[self.hero][@"bio"];
    self.title = self.hero;
    NSDictionary *allAbility = [NSDictionary dictionaryWithContentsOfFile:[dataPath stringByAppendingPathComponent:@"ablitydata.plist"]];
    self.abilityList = [NSMutableDictionary dictionary];
    for (NSString *name in allAbility) {
        if ([name hasPrefix:[self.hero stringByAppendingString:@"_"]]) {
            [self.abilityList setObject:allAbility[name] forKey:name];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Ability";
    } else {
        return @"Bio";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return self.abilityList.count;
    } else {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        XYZAbilityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AbilityCell" forIndexPath:indexPath];
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        cell.abilityLabel.text = self.abilityList[[self.abilityList allKeys][indexPath.row]][@"dname"];
        cell.abilityDetailLabel.text = self.abilityList[[self.abilityList allKeys][indexPath.row]][@"desc"];
        cell.abilityDetailLabel.numberOfLines = 0;
        //cdn.dota2.com/apps/dota2/images/abilities/sniper_headshot_hp1.png
        NSURL *abilityImageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.dota2.com/apps/dota2/images/abilities/%@_hp1.png",[self.abilityList allKeys][indexPath.row]]];
        [cell.abilityImageView sd_setImageWithURL:abilityImageURL];
        return cell;
    } else {
        XYZBioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BioCell" forIndexPath:indexPath];
        cell.textLabel.text = self.heroBio;
        cell.textLabel.font = [UIFont fontWithName:nil size:15];
        cell.textLabel.numberOfLines = 0;
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        return cell;
    }
}

//iOS7里计算行高,会覆盖self.tableView.estimatedRowHeight self.tableView.rowHeightde 的设置 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 100;
    } else {
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 25, MAXFLOAT);
        NSMutableDictionary *attrsDict = [NSMutableDictionary dictionary];
        attrsDict[NSFontAttributeName] = [UIFont systemFontOfSize:15];
        return [self.heroBio boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrsDict context:nil].size.height;
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
