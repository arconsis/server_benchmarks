package com.arconsis.bookstorespringboot.config

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.InjectionPoint
import org.springframework.beans.factory.config.BeanDefinition.SCOPE_PROTOTYPE
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Scope

@Configuration
class LoggingConfig {

    @Bean
    @Scope(SCOPE_PROTOTYPE)
    fun logger(injectionPoint: InjectionPoint): Logger {
        return LoggerFactory.getLogger(
            injectionPoint.methodParameter?.containingClass
                ?: injectionPoint.field?.declaringClass
        )
    }
}