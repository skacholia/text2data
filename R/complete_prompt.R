#' Complete a Custom GPT Prompt
#'
#' @param prompt The prompt to use as input for GPT
#' @param model  Which model variant of GPT to use. Defaults to 'gpt-3.5-turbo'
#' @param openai_api_key Your API key. By default, looks for a system environment variable called "OPENAI_API_KEY" (recommended option). Otherwise, it will prompt you to enter the API key as an argument.
#' @param max_tokens How many tokens (roughly 4 characters of text) should GPT return? Defaults to a single token (next word prediction).
#' @param temperature A number between 0 and 2. When set to zero, GPT will always return the most probable next token. When set higher, GPT will select the next word probabilistically.
#'
#' @return A string of text generated by GPT.
#' @export
#'
#' @examples
#' complete_prompt('I feel like a')
#' complete_prompt('Write a haiku about frogs.', max_tokens = 100)
complete_prompt <- function(prompt,
                            model = 'gpt-3.5-turbo',
                            openai_api_key = Sys.getenv('OPENAI_API_KEY'),
                            max_tokens = as.integer(1),
                            temperature = as.integer(0)) {
  
                openai <- reticulate::import("openai")
              
              if(openai_api_key == ''){
                stop("No API key detected in system environment. You can enter it manually using the 'openai_api_key' argument.")
              } else{
                openai$api_key = openai_api_key
              }
              
              # query the API
              response <- openai$ChatCompletion$create(
                model = model,
                messages = list(
                  list("role" = "system", "content" = "You are a helpful assistant."),
                  list("role" = "user", "content" = prompt)
                ),
                max_tokens = as.integer(max_tokens),
                temperature = as.integer(temperature)
              )
              
              return(response$choices[[1]]$message$content)
}