use argh::FromArgs;

#[derive(FromArgs, Debug)]
/// Reach new heights.
struct Config {
    /// whether to be verbose
    #[argh(switch, short = 'v')]
    verbose: bool,

    /// an optional name to green
    #[argh(option)]
    name: Option<String>,
}

fn main() {
    let cfg: Config = argh::from_env();
    if cfg.verbose {
        println!("DEBUG {cfg:?}");
    }
    println!("Hello {}!", cfg.name.unwrap_or("world".to_string()));
}
