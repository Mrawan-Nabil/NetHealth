import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../wayfinder'
/**
 * @see routes/web.php:7
 * @route '/'
 */
export const home = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: home.url(options),
    method: 'get',
})

home.definition = {
    methods: ["get","head"],
    url: '/',
} satisfies RouteDefinition<["get","head"]>

/**
 * @see routes/web.php:7
 * @route '/'
 */
home.url = (options?: RouteQueryOptions) => {
    return home.definition.url + queryParams(options)
}

/**
 * @see routes/web.php:7
 * @route '/'
 */
home.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: home.url(options),
    method: 'get',
})
/**
 * @see routes/web.php:7
 * @route '/'
 */
home.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: home.url(options),
    method: 'head',
})

    /**
 * @see routes/web.php:7
 * @route '/'
 */
    const homeForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: home.url(options),
        method: 'get',
    })

            /**
 * @see routes/web.php:7
 * @route '/'
 */
        homeForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: home.url(options),
            method: 'get',
        })
            /**
 * @see routes/web.php:7
 * @route '/'
 */
        homeForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: home.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    home.form = homeForm
/**
* @see \App\Http\Controllers\AuthController::login
 * @see app/Http/Controllers/AuthController.php:17
 * @route '/login'
 */
export const login = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: login.url(options),
    method: 'get',
})

login.definition = {
    methods: ["get","head"],
    url: '/login',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\AuthController::login
 * @see app/Http/Controllers/AuthController.php:17
 * @route '/login'
 */
login.url = (options?: RouteQueryOptions) => {
    return login.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\AuthController::login
 * @see app/Http/Controllers/AuthController.php:17
 * @route '/login'
 */
login.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: login.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\AuthController::login
 * @see app/Http/Controllers/AuthController.php:17
 * @route '/login'
 */
login.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: login.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\AuthController::login
 * @see app/Http/Controllers/AuthController.php:17
 * @route '/login'
 */
    const loginForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: login.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\AuthController::login
 * @see app/Http/Controllers/AuthController.php:17
 * @route '/login'
 */
        loginForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: login.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\AuthController::login
 * @see app/Http/Controllers/AuthController.php:17
 * @route '/login'
 */
        loginForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: login.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    login.form = loginForm
/**
 * @see routes/web.php:15
 * @route '/register'
 */
export const register = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: register.url(options),
    method: 'get',
})

register.definition = {
    methods: ["get","head"],
    url: '/register',
} satisfies RouteDefinition<["get","head"]>

/**
 * @see routes/web.php:15
 * @route '/register'
 */
register.url = (options?: RouteQueryOptions) => {
    return register.definition.url + queryParams(options)
}

/**
 * @see routes/web.php:15
 * @route '/register'
 */
register.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: register.url(options),
    method: 'get',
})
/**
 * @see routes/web.php:15
 * @route '/register'
 */
register.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: register.url(options),
    method: 'head',
})

    /**
 * @see routes/web.php:15
 * @route '/register'
 */
    const registerForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: register.url(options),
        method: 'get',
    })

            /**
 * @see routes/web.php:15
 * @route '/register'
 */
        registerForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: register.url(options),
            method: 'get',
        })
            /**
 * @see routes/web.php:15
 * @route '/register'
 */
        registerForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: register.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    register.form = registerForm
/**
 * @see routes/web.php:19
 * @route '/register/patient'
 */
export const RegisterPatient = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: RegisterPatient.url(options),
    method: 'get',
})

RegisterPatient.definition = {
    methods: ["get","head"],
    url: '/register/patient',
} satisfies RouteDefinition<["get","head"]>

/**
 * @see routes/web.php:19
 * @route '/register/patient'
 */
RegisterPatient.url = (options?: RouteQueryOptions) => {
    return RegisterPatient.definition.url + queryParams(options)
}

/**
 * @see routes/web.php:19
 * @route '/register/patient'
 */
RegisterPatient.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: RegisterPatient.url(options),
    method: 'get',
})
/**
 * @see routes/web.php:19
 * @route '/register/patient'
 */
RegisterPatient.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: RegisterPatient.url(options),
    method: 'head',
})

    /**
 * @see routes/web.php:19
 * @route '/register/patient'
 */
    const RegisterPatientForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: RegisterPatient.url(options),
        method: 'get',
    })

            /**
 * @see routes/web.php:19
 * @route '/register/patient'
 */
        RegisterPatientForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: RegisterPatient.url(options),
            method: 'get',
        })
            /**
 * @see routes/web.php:19
 * @route '/register/patient'
 */
        RegisterPatientForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: RegisterPatient.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    RegisterPatient.form = RegisterPatientForm
/**
 * @see routes/web.php:23
 * @route '/register/doctor'
 */
export const RegisterDoctor = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: RegisterDoctor.url(options),
    method: 'get',
})

RegisterDoctor.definition = {
    methods: ["get","head"],
    url: '/register/doctor',
} satisfies RouteDefinition<["get","head"]>

/**
 * @see routes/web.php:23
 * @route '/register/doctor'
 */
RegisterDoctor.url = (options?: RouteQueryOptions) => {
    return RegisterDoctor.definition.url + queryParams(options)
}

/**
 * @see routes/web.php:23
 * @route '/register/doctor'
 */
RegisterDoctor.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: RegisterDoctor.url(options),
    method: 'get',
})
/**
 * @see routes/web.php:23
 * @route '/register/doctor'
 */
RegisterDoctor.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: RegisterDoctor.url(options),
    method: 'head',
})

    /**
 * @see routes/web.php:23
 * @route '/register/doctor'
 */
    const RegisterDoctorForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: RegisterDoctor.url(options),
        method: 'get',
    })

            /**
 * @see routes/web.php:23
 * @route '/register/doctor'
 */
        RegisterDoctorForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: RegisterDoctor.url(options),
            method: 'get',
        })
            /**
 * @see routes/web.php:23
 * @route '/register/doctor'
 */
        RegisterDoctorForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: RegisterDoctor.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    RegisterDoctor.form = RegisterDoctorForm