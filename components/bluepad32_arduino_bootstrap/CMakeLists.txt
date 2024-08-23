include(CMakePrintHelpers)

set(srcs
        "main.c"
        )

 set(requires
         arduino
         bluepad32
         bluepad32_arduino
         btstack)


idf_component_register(SRCS "${srcs}"
                REQUIRES ${requires})
