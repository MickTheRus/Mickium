def 'complete container id' [] { ^docker ps -qa | lines }
def 'complete container name' [] { ^docker ps -a --format '{{.Names}}' | lines | split row ',' }
def 'complete container either' [] { complete container id | append (complete container name) }
def 'complete running container id' [] { ^docker ps -q | lines }
def 'complete running container name' [] { ^docker ps --format '{{.Names}}' | lines | split row ',' }
def 'complete running container either' [] { complete running container id | append (complete running container name) }
def 'complete image repo' [] { ^docker image ls --format '{{.Repository}}' | lines | where $it != '<none>' }

# Attach local standard input, output, and error streams to a running container
export extern attach [
	--detach-keys: string  # Override the key sequence for detaching a container
	--no-stdin  # Do not attach STDIN
	--sig-proxy  # Proxy all received signals to the process (default true)
	container: string@'complete running container either'  #
]

# Build an image from a Dockerfile
export extern build [
	--add-host: string  # Add a custom host-to-IP mapping (host:ip)
	--build-arg: string  # Set build-time variables
	--cache-from: string@'complete image repo'  # Images to consider as cache sources
	--cgroup-parent: string  # Optional parent cgroup for the container
	--compress  # Compress the build context using gzip
	--cpu-period: int # Limit the CPU CFS (Completely Fair Scheduler) period
	--cpu-quota: int  # Limit the CPU CFS (Completely Fair Scheduler) quota
	--cpu-shares(-c): int  # CPU shares (relative weight)
	--cpuset-cpus: string  # CPUs in which to allow execution (0-3, 0,1)
	--cpuset-mems: string  # MEMs in which to allow execution (0-3, 0,1)
	--disable-content-trust  # Skip image verification (default true)
	--file(-f): path  # Name of the Dockerfile (default: "PATH/Dockerfile")
	--force-rm  # Always remove intermediate containers
	--iidfile: path  # Write the image ID to the file
	--isolation: string  # Container isolation technology
	--label: string  # Set metadata for an image
	--memory(-m): string # Memory limit (bytes)
	--memory-swap: string # Swap limit equal to memory plus swap: '-1' to enable unlimited swap
	--network: string  # Set the networking mode for the RUN instructions during build (default "default")
	--no-cache  # Do not use cache when building the image
	--pull  # Always attempt to pull a newer version of the image
	--quiet(-q)  # Suppress the build output and print image ID on success
	--rm  # Remove intermediate containers after a successful build (default true)
	--security-opt: string  # Security options
	--shm-size: string  # Size of /dev/shm
	--tag: string  # Name and optionally a tag in the 'name:tag' format
	--target: string  # Set the target build stage to build.
	--ulimit: string = '[]' # Ulimit options
	arg: string  # PATH, URL, or -
]

# Create a new image from a container's changes
export extern commit [
	--author(-a): string  # Author (e.g., "John Hannibal Smith <hannibal@a-team.com>")
	--change(-c): string  # Apply Dockerfile instruction to the created image
	--message(-m): string  # Commit message
	--pause(-p)  # Pause container during commit (default true)
	container: string@'complete container either'
	repo_and_tag?: string  # REPOSITORY[:TAG]
]

# Kill one or more running containers
export extern kill [
	--signal(-s): string = 'KILL' # Signal to send to the container
	...container: string@'complete running container either'
]

# List containers
export def ps [
	--all(-a)  # Show all containers (default shows just running)
	--filter(-f): string  # Filter output based on conditions provided
	#--format: string  # Pretty-print containers using a Go template
	--last(-n): int = -1  # Show n last created containers (includes all states)
	--no-trunc  # Don't truncate output
	--quiet(-q)  # Only display container IDs
	--size(-s)  # Display total file sizes
] {
	^docker ps ([
		(if $all {'--all'})
		(if $filter != null {['--filter' $filter]})
		#(if $format != null {['--format' $format]}
		'--last' $last
		(if $no_trunc {'--no-trunc'})
		(if $quiet {'--quiet'})
		(if $size {'--size'})
	] | compact | flatten)
	| from ssv -m 2
	| each {|i|
		$i
		| update NAMES { $i.NAMES | split row ',' }
	}
}

# Remove one or more containers
export extern rm [
	--force(-f)   # Force the removal of a running container (uses SIGKILL)
	--link(-l)    # Remove the specified link
	--volumes(-v) # Remove anonymous volumes associated with the container
	...container: string@'complete container either'
]

# Start one or more stopped containers
export extern start [
	--attach(-a)  # Attach STDOUT/STDERR and forward signals
	--detach-keys: string  # Override the key sequence for detaching a container
	--interactive(-i)  # Attach container's STDIN
	...container: string@'complete container either'
]
