//
//  TGSVSideBarStack.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2022/12/28.
//

import SwiftUI

struct TGSVSideBarStack<SidebarContent: View, Content: View>: View {
    let sidebarContent: SidebarContent
    let mainContent: Content
    let sidebarWidth: CGFloat
    @Binding var showSidebar: Bool
    @Binding var sideDirection: TGSSidemenuSceneModel.SIDE_MENU_DIRECTION
    
    
    init(sidebarWidth: CGFloat, showSidebar: Binding<Bool>, sideDirection: Binding<TGSSidemenuSceneModel.SIDE_MENU_DIRECTION>,
         @ViewBuilder sidebar: ()->SidebarContent, @ViewBuilder content: ()->Content) {
        self.sidebarWidth = sidebarWidth
        self._showSidebar = showSidebar
        self._sideDirection = sideDirection
        sidebarContent = sidebar()
        mainContent = content()
    }
    
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if(sideDirection == TGSSidemenuSceneModel.SIDE_MENU_DIRECTION.LEFT) {
                    if $0.translation.width < -100 {
                        withAnimation {
                            self.showSidebar = false
                        }
                    }
                } else {
                    if $0.translation.width < 100 {
                        withAnimation {
                            self.showSidebar = false
                        }
                    }
                }
            }
        
        
        ZStack(alignment: (sideDirection == TGSSidemenuSceneModel.SIDE_MENU_DIRECTION.LEFT) ? .leading : .trailing) {
            mainContent
                .overlay(
                    Group {
                        if showSidebar {
                            Color.white
                                .opacity(showSidebar ? 0.01 : 0)
                                .onTapGesture {
                                    self.showSidebar = false
                                }
                        } else {
                            Color.clear
                                .opacity(showSidebar ? 0 : 0)
                                .onTapGesture {
                                    self.showSidebar = false
                                }
                        }
                    }
                )
                //.offset(x: showSidebar ? sidebarWidth : 0, y: 0)
                .animation(Animation.easeInOut.speed(2))
                .gesture(drag)
            sidebarContent
                .frame(width: sidebarWidth, alignment: .center)
                .background(Rectangle().fill(Color.white).shadow(radius: 8))
                //.offset(x: showSidebar ? 0 : -1 * sidebarWidth, y: 0)
                .offset(x: showSidebar ? 0 : getSidebarXEnd(), y: 0)
                .animation(Animation.easeInOut.speed(2))
            
            
        }
    }
    
    
    func getSidebarXEnd() -> CGFloat {
        if(sideDirection == TGSSidemenuSceneModel.SIDE_MENU_DIRECTION.LEFT) {
            return -1 * sidebarWidth
            
        } else {
            return  sidebarWidth
        }
    }
}

