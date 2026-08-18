// Import and register all your controllers from the importmap under views/*
// Eager load all controllers defined in the import map under views/**/*_view
import { eagerLoadViewsFrom } from "helpers/defo-loading"
eagerLoadViewsFrom("views")
