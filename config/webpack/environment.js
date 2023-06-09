import { ProvidePlugin } from 'webpack'
environment.plugins.prepend('Provide',
new ProvidePlugin({
  $: 'jquery/src/jquery',
  jQuery: 'jquery/src/jquery'
})
)
