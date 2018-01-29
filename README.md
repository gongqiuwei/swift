# swift
swift学习记录
xcode版本：xcode8.2.1 swift版本：swift3.0

# swift项目实战

### 一、基本框架的搭建
- 项目的部署(远程仓库)
	- 部署方式
	
		github/OSChina/SVN(一般公司内部使用)
	
	- 注意点： 

		.gitignore需要将pods文件屏蔽，一般不上传pods库到远程仓库，只上传podfile文件，本地 pod update/ pod install
		
		各种语言 .gitignore文件 [gitHub地址](https://github.com/github/gitignore)
		
- 项目初始化
	
	- 1、将远程仓库clone到本地（svn checkout）
	- 2、在本地仓库中创建新的项目（.git隐藏文件所在的同级目录下或者.svn隐藏文件所在的同级目录下）
	- 3、将创建好的项目推送到远程仓库中
	
- 项目基本设定
	- General设定: 
		- display name: app显示的名称
		- deployment target: 最低支持设备的版本
		- devices: 支持设备类型（iPhone/iPad/Universal）
		- device orentation: 横竖屏

		注意：项目设定为iPhone 9.0， 主要是为了使用Storyboard的reference功能（storyboard切割或者模块划分）
		
	- 项目appicon、启动图片

		- 设置appicon与启动图片
		
		![](Images/Snip20180126_1.png)
		
		![](Images/Snip20180126_2.png)
		
		- waring处理
		warning: Ambiguous Content: The launch image set "LaunchImage" has 2 unassigned children.

		删除下面的unassigned
		![](Images/Snip20180126_3.png)
		
		
- 项目文件(模块划分)/ 项目目录结构划分

	根据项目的需求，划分为4大模块5个主要文件夹，用于后期增加代码时源文件的存储位置，项目文件规范存储，便于后期查找
	
	![](Images/Snip20180126_4.png)
	
	
- 项目主界面初始化

	- 纯代码方式
	
		- Appdelegate.swift中
	
		```swift
		func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	        
	        // 设置全局颜色
	        UITabBar.appearance().tintColor = UIColor.orangeColor()
	        
	        // 创建window
	        window = UIWindow(frame: UIScreen.mainScreen().bounds)
	        window?.rootViewController = MainViewController()
	        window?.makeKeyAndVisible()
	        
	        return true
	    }
		```
	
		- MainViewController中
	
		```swift
		override func viewDidLoad() {
	        super.viewDidLoad()
	                
	        // 添加子控制器
	        addChildViewController(HomeViewController(), title: "首页", imageName: "tabbar_home")
	        addChildViewController(MessageViewController(), title: "消息", imageName: "tabbar_message_center")
	        addChildViewController(DiscoverViewController(), title: "发现", imageName: "tabbar_discover")
	        addChildViewController(ProfileViewController(), title: "我", imageName: "tabbar_profile")
	    }
	    
	    // swift支持方法的重载
	    // 方法的重载:方法名称相同,但是参数不同. --> 1.参数的类型不同 2.参数的个数不同
	    // private：访问控制，只有当前类能访问(swift3.0之后当前文件的extension 也不能访问)
	    // fileprivate: 当前文件能访问
	    private func addChildViewController(_ childVc: UIViewController, title: String, imageName: String) {
	        
	        // setTitleTextAttributes设置字体等属性
	        childVc.tabBarItem.title = title
	        childVc.tabBarItem.image = UIImage(named: imageName)
	        childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
	        
	        let nav = UINavigationController(rootViewController: childVc)
	        addChildViewController(nav)
	    }
		```
	
		- 注意点：(swift语法)
	
		1. 方法的重载：
	 
	 		`方法名称相同,但是参数不同. --> 1.参数的类型不同 2.参数的个数不同`
		2. 访问控制：
		
			`private` `fileprivate` 等
	
	
	
	-  动态创建控制器对象
		- swfit中直接从利用类名无法创建出对象，这点与OC不同，在于swift的namespace机制
		
			```swift
			class MainViewController: UITabBarController {

    			override func viewDidLoad() {
        			super.viewDidLoad()
        		
        			print(self)	
        		}
			
			// 输出结果
			// 前面的SwiftWeiBo就是当前类所在的namespace名称
			// <SwiftWeiBo.MainViewController: 0x7fa3745072a0>
			```
		- swift使用类名创建控制器
			
			```swift
			/// 通过类名创建控制器(直接使用类名无法生成class，原因在与swift的命名空间namespace)
			private func viewController(forName vcName:String ) -> UIViewController? {
				// 1.获取命名空间名称（swift3.0 NSBundle改为Bundle）
        		guard let infoDict = Bundle.main.infoDictionary else {
            		// 获取不到infodict
            		return nil
        		}
				guard let namespace = infoDict["CFBundleExecutable"] as? String else {
            		// CFBundleExecutable的值取不到
            		return nil
        		}
        		
        		// 2.拼接完整的类名
        		let vcClassName = namespace + "." + vcName
        		
        		// 3.通过类名创建对象
        		guard let vcClass = NSClassFromString(vcClassName) else {
            		return nil
        		}
        		guard let vcClassType = vcClass as? UIViewController.Type else {
        			return nil
        		}
        		let vc = vcClassType.init()
        		
        		return vc
			}
			```
	
		
		- 注意点:
		
		1. swift的namespace机制，导致类名的className格式为`namespace.classname`
			
			如何获取当前namesapce 参考博客：<http://blog.csdn.net/chengkaizone/article/details/50533858>
		
		2.  swift中通过classname创建对象与OC完全不一样
		
			参考：<https://mp.weixin.qq.com/s?__biz=MzIzMzA4NjA5Mw==&mid=213993163&idx=1&sn=95cf79bed2707961ec1a6c17c9103d8a&scene=18#rd>
	
	
	- 通过json文件动态初始化主界面
	
		```swift
		private func addChildViewControllerFromJsonFile() {
			// 1.获取json文件路径
        	guard let filePath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
          		return;
        	}
        	
        	// 2.读取jsondata
        	guard let jsonData = NSData(contentsOfFile: filePath) as? Data else {
            	return
        	}
        	
        	// 3.解析jsondata（需要捕捉异常）
			guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            	return;
        	}
        	
        	// 4.将Any转成[[String:String]]
        	guard let dictArr = anyObject as? [[String:String]] else {
            	return;
        	}
        	
        	// 5.遍历，添加子控制器
        	for dict in dictArr {
        	// 注意，需要使用continue 
		        guard let childVcName = dict["vcName"] else {
		            continue
		        }
	    
		        guard let title = dict["title"] else {
		            continue
		        }
	    
		        guard let imageName = dict["imageName"] else {
		            continue
		        }
	    	
		    	addChildViewController(childVcName: childVcName, title: title, imageName: imageName)
        	}
		}
		
		/// 通过类名添加子控制器
		private func addChildViewController(childVcName: String, title: String, imageName: String) {
			// viewController(forName: childVcName)，上面使用类名创建控制器
    		guard let childVc = viewController(forName: childVcName) else {
        		return;
    		}
    		childVc.tabBarItem.title = title
    		childVc.tabBarItem.image = UIImage(named: imageName)
    		childVc.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
    
    		let nav = UINavigationController(rootViewController: childVc)
    		addChildViewController(nav)
		}
		```
		
		- 注意点
			
			1. json文件数据读取进来是一堆二进制数据（NSData/Data）,需要进行序列化
			2. swift中异常的捕捉:
				如果在调用系统某一个方法时,该方法最后有一个throws.说明该方法会抛出异常.如果一个方法会抛出异常,那么需要对该异常进行处理
				* 第一种: try方式 程序员手动捕捉异常
					
					```swift
					do {
        				let anyObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    				} catch {
       	 				print(error)
    				}
					```
					
				* 第二种 try?方式 (常用方式) 系统帮助我们处理异常,如果该方法出现了异常,则该方法返回nil.如果没有异常,则返回对应的对象
				
					```swift
					guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            			return;
        	}
					```
				
				* 第三种 try!方式(不建议,非常危险) 直接告诉系统,该方法没有异常.注意:如果该方法出现了异常,那么程序会报错(崩溃)
	
					```swift
					let anyObject = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: .MutableContainers)
					```
					
	- 使用Main.Storyboard初始化主界面
	
		- 使用storyboard reference划分模块
		
		![](Images/Snip20180128_3.png)
		
		- TabbarItem的设定
		
		![](Images/Snip20180128_5.png)
		
		- Tabbar中间加号按钮的设定
		
			1. 使用一个空白的控制器在tabbar中占一个位置，并设置item的enable属性为false
		![](Images/Snip20180128_7.png)
		
			2. 使用代码添加加号按钮
		
			MainViewController.swift中
			
			```swift
			fileprivate func setupComposeBtn() {
	        	tabBar.addSubview(composeBtn)
	        
	        	// 设置属性
	        	composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), for: .normal)
	        	composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: .highlighted)
	        	composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), for: .normal)
	       	composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: .highlighted)
	        
	        	// 设置位置尺寸
	        	// 设置好图片后，可以使用这个方法让按钮尺寸进行自适应
	        	composeBtn.sizeToFit()
	        
	        	// swift中结构体的创建，使用init构造函数
	        	// composeBtn.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height*0.5)
	        	composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height*0.5)
	    	}
			```
		
		
		- 扩充知识

			1. 抽取常用代码到Extension中，（OC是抽取到cagetory中）
				
				UIButton-Extension.swift文件对系统类UIButton进行方法扩充
				
				```swift
				// swift中类方法是以class开头的方法.类似于OC中+开头的方法
				class func createBtn(imageName:String, bgImageName:String) -> UIButton {
					let btn = UIButton()
					
					btn.setBackgroundImage(UIImage(named: bgImageName), for: .normal)
					btn.setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
					btn.setImage(UIImage(named: imageName), for: .normal)
					btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
					
					// 设置好图片后，可以使用这个方法让按钮尺寸进行自适应
					btn.sizeToFit()
					
					return btn
				}
				
				
				/*
				便利构造函数
				使用convenience修饰的构造函数叫做便利构造函数
				便利构造函数通常用在对系统的类进行构造函数的扩充时使用
				
				遍历构造函数的特点
				1.遍历构造函数通常都是写在extension里面
				2.遍历构造函数init前面需要加载convenience
				3.在遍历构造函数中需要明确的调用self.init()或其他已提供的构造函数
				*/
				convenience init(imageName:String, bgImageName:String) {
					// 调用self.init,或者提供的其他构造函数，显示调用
					self.init()
					
					// 属性设置
					setBackgroundImage(UIImage(named: bgImageName), for: .normal)
					setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
					setImage(UIImage(named: imageName), for: .normal)
					setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
					
					// 设置好图片后，可以使用这个方法让按钮尺寸进行自适应
					sizeToFit()
				}
				```
			
				 - 小结：
				
					swift中，快速创建对象，推荐使用构造函数，而不是像OC中使用类方法
					
					例如：
						UIImage
					 	
					 	*  [UIImage imageName:imageName]; // OC
						*  UIImage(name:imageName); // swift
			2. swift按钮点击事件
			
				- 事件监听原理
					
					* 事件监听本质发送消息.但是发送消息是OC的特性
					* 将方法包装成@SEL --> 类中查找方法列表 --> 根据@SEL找到imp指针(函数指针) --> 执行函数
					* 如果swift中将一个函数声明称private/fileprivate,那么该函数不会被添加到方法列表中
					* 如果在private前面加上`@objc`,那么该方法依然会被添加到方法列表中
				- swift中SEL包装
					* 无参数 `#selector(composeBtnClicked)`
					* 带参数 `#selector(composeBtnClicked(sender:))`
					
					```swift
					func composeBtnClicked() {
						print("---composeBtnClicked---")
					}
					
					func composeBtnClicked(sender: UIButton) {
						print("---composeBtnClicked--\(sender)-")
					}
					```
				- 示例：按钮事件监听
					- 参考1： <http://swift.gg/2016/07/27/swift3-changes/>
					- 参考2：<http://swift.gg/2016/06/02/swift-selector-syntax-sugar/>
					
					swift在编译时期就检查#selector是否存在，相对于OC更安全，提前发现错误
					
					```swift
					// 建议在方法明前面加上类名（编译时期）
					composeBtn.addTarget(self, action: #selector(MainViewController.composeBtnClicked(sender:)), for: .touchUpInside)
					
					// 函数声明称private/fileprivate,那么该函数不会被添加到方法列表中
					// 前面加上@objc,表示是OC类型的消息函数，需要添加到方法列表中
					@objc fileprivate func composeBtnClicked(sender: UIButton) {
						print("---composeBtnClicked--\(sender)-")
					}
					```
					
			3. 一个警告的处理 missing file from working copy
			
				![](Images/Snip20180128_9.png)
			
				- 警告原因：git 管理了工程文件，但是在删除过程中处理不当，没有通过git进行文件删除导致
				- 处理参考：<http://blog.csdn.net/gdutxzy/article/details/41476965>

- 需求一： 未登录情况下的访客视图

	- 需求： 