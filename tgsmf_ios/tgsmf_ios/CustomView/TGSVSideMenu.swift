//
//  TGSVSideMenu.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/29.
//

import SwiftUI


struct TGSVSideMenu : View {
    @Binding var showMenu : Bool
    var menuList : [TGSMMenu]
   //@ObservedObject var command : TGSMCommad = TGSUCommand.cmd
    @ObservedObject var command : TGSMCommad
    
//    init(showMenu : Binding<Bool>, menuList: Array<TGSMMenu>) {
//        self._showMenu = showMenu
//        self.menuList = menuList
//        UITableView.appearance().backgroundColor = .clear
//    }
    
    func onMenuClickEvent(clickevent:String) {
        let cmd = TGSUCommand.convertWebCommand(clickevent)
        if(cmd != nil) {
            command.currCommand.send(cmd!)
            self.showMenu = false
        }
        //command.updateCurrCommand(strCommand: self.menu.clickEvent ?? "")
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    Button(action:{  withAnimation{ showMenu.toggle() } } ) {
                        TGSVImage(R.Image.gnb_close1, contentMode: .fit)
                            .frame(width: 18)
                    }
                    .padding(.trailing, 20)
                }
                .frame( height: 50)
                //.padding(.top, 50)
                .background(R.Color.color_sidemenu_top_bg)
                ScrollView() {
                    ForEach(menuList) { menu in
                        sideMenu1Depth(menu: menu, command: self.command, clickHandler: onMenuClickEvent)
                    }
                }
            }
            .frame(maxWidth: geometry.size.width, alignment: .topLeading)
            .background(Color.white)
        }
    }
    
    

    struct sideMenu3Depth : View {
        var menu :TGSMMenu
        var haveExpanded : Bool
        
        @ObservedObject var command : TGSMCommad
        
        @State var isExpanded : Bool = true
        
        var clickHandler: (String) -> ()
    

        init(menu: TGSMMenu, command: TGSMCommad, clickHandler : @escaping (String)->()) {
            self.menu = menu
            self.command = command
            self.clickHandler = clickHandler
            self.haveExpanded = (menu.arraySub?.isEmpty ?? true) ? false : true
           
        }
        
        var body: some View {
            GeometryReader { geometry in
                VStack{
                    HStack {
                        TGSVImage(R.Image.gnb_d3_ic1, contentMode: .fit)
                            .frame(width: 3)
                        
                        Button(action: {
                            if(self.menu.clickEvent != nil) {
                                clickHandler(self.menu.clickEvent!)
                            }
                        }) {
                            Text(menu.menuName)
                                .font(R.Font.font_noto_m(size: 12))
                                .foregroundColor(R.Color.color_sidemenu_sub_text)
                        }
                    
                    }
                }
                .frame(maxWidth: geometry.size.width, alignment: .leading)
                //.frame(maxWidth: .infinity, alignment: .leading)
                
            }
        }
    }
    
    struct sideMenu2Depth : View {
        var menu :TGSMMenu
        @ObservedObject var command : TGSMCommad
        var haveExpanded : Bool
        
        @State var isExpanded : Bool = true
        
        var clickHandler: (String) -> ()
        
        init(menu: TGSMMenu, command: TGSMCommad, clickHandler : @escaping (String)->()) {
            self.menu = menu
            self.command = command
            self.clickHandler = clickHandler
            self.haveExpanded = (menu.arraySub?.isEmpty ?? true) ? false : true
            self.isExpanded = self.haveExpanded
        }
        
        var body: some View {
            VStack{
                HStack {
                    Button(action: {
                        if(haveExpanded) {
                            withAnimation { self.isExpanded.toggle()}
                        } else {
                            if(self.menu.clickEvent != nil) {
                                clickHandler(self.menu.clickEvent!)
                            }
                            
                        }
                        
                    }) {
                        Text(menu.menuName)
                            .font(R.Font.font_noto_m(size: 14))
                            .foregroundColor(self.isExpanded ? R.Color.color_sidemenu_sub_on_text : R.Color.color_sidemenu_sub_text)
                        Spacer()
                        if(self.haveExpanded) {
                            TGSVImage( self.isExpanded ? R.Image.gnb_d2_ic1 : R.Image.gnb_d2on_ic1, contentMode: .fit)
                                .frame(width: 14)
                        }
                    }
                    
                }
                .frame(height: 36)
                //.frame(width: .infinity, height: 36)
                            
                
                if(self.haveExpanded && self.isExpanded) {
                    VStack {
                        ForEach(menu.arraySub!) { child in
                            sideMenu3Depth(menu: child, command: self.command, clickHandler: self.clickHandler)
                                .padding(.vertical, 3)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                            .background(Color.white.cornerRadius(10))
                    )
                }
            }
        }
    }

    struct sideMenu1Depth : View {
        var menu :TGSMMenu
        @ObservedObject var command : TGSMCommad
        var haveExpanded : Bool
        @State var isExpanded : Bool = true
        var clickHandler: (String) -> ()
        
        
        init(menu: TGSMMenu, command :TGSMCommad, clickHandler : @escaping (String)->()) {
            self.menu = menu
            self.command = command
            self.clickHandler = clickHandler
            self.haveExpanded = (menu.arraySub?.isEmpty ?? true) ? false : true
            self.isExpanded = self.haveExpanded

        }
        
        var body: some View {
            VStack{
                HStack {
                    Text(menu.menuName)
                        .font(R.Font.font_gmarket_m(size: 16))
                        .foregroundColor(self.isExpanded ? R.Color.color_sidemenu_title_on_text : R.Color.color_sidemenu_title_text)
                    Spacer()
                    TGSVImage(self.isExpanded ? R.Image.gnb_d1on_ic1 : R.Image.gnb_d1_ic1, contentMode: .fit)
                        .frame(width: 17)
                }
                .frame(height: 55)
                .padding(.horizontal, 20)
                .onTapGesture {
                    if(haveExpanded) {
                        withAnimation { self.isExpanded.toggle()}
                    } else {
                        if(self.menu.clickEvent != nil) {
                            clickHandler(self.menu.clickEvent!)
                        }
                    }
                }
                
                if(self.isExpanded) {
                    VStack {
                        ForEach(menu.arraySub!) { child in
                            sideMenu2Depth(menu: child, command: self.command, clickHandler: self.clickHandler)
                        }
                    }
                    .padding(20)
                    .background(R.Color.color_sidemenu_sub_bg)
                }
            }
        }
    }
    
}



struct TGSVSideMenu_Previews: PreviewProvider {
    
    static var previews: some View {
        TGSVSideMenu(showMenu: .constant(true), menuList: SideMenuSample, command: TGSMCommad())
    }
}
