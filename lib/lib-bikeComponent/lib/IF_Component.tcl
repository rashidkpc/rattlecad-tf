    namespace eval bikeComponent {
            #
        namespace ensemble create -command ::bikeComponent::IF_Component \
                -map {
                        
                        init                        init
                        
                        create_LibraryWidget        create_LibraryWidget
                        
                        add_ComponentDir            add_ComponentDir
                        
                        set_Config                  set_Config
                        set_ListValue               set_ListValue
                        set_Scalar                  set_Scalar
                        set_Placement               set_Placement
                        
                        get_ComponentNode           get_ComponentNode
                        get_ComponentPath           get_ComponentPath
                        get_Config                  get_Config
                        get_Direction               get_Direction
                        get_Strategy                get_Strategy
                        get_ListBoxValues           get_ListBoxValues
                        get_ListValue               get_ListValue
                        get_Polygon                 get_Polygon
                        get_Polyline                get_Polyline
                        get_Position                get_Position
                        get_Scalar                  get_Scalar
                        get_Vector                  get_Vector
                        
                        get_ComponentDirectories    get_ComponentDirectories
                        get_ComponentBaseDirectory  get_ComponentBaseDirectory
                        get_ComponentSubDirectories get_ComponentSubDirectories
                        get_ComponentKey            get_ComponentKey
                        get_CompAlternatives        get_CompAlternatives
                        
                        update_DirStructure         update_DirStructure
                        update_Component            update_Component
                        
                    }

    }

                    #   set_UserDir                 set_UserDir
                    #   set_CustomDir               set_CustomDir
                    #   set_Strategy                set_Strategy
                                               