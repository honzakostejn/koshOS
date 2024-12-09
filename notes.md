# DAY 1
## Demystifying Privacy Preserving Computing
Focused on privacy in the era of data. How to train models without breaching privacy. This topic must be understood in the context of security and privacy. This talk was looking into the privacy part. The main techniques are:
- Federated learning - training models on the device and sending the results to the server. The results must be averaged, so that privacy is preserved.
- Differential privacy - adding noise to the data. The results are more or less precise, because the noise is similar on a large dataset. But due to the noise, privacy is preserved.
- Secure multi-party computation - splitting the data into encrypted parts, doing the computation on different nodes and then constructing the results. Each node has only a part of the data, so the privacy is preserved.
- Homomorphic encryption - the data is encrypted and the operations are defined on top of the encrypted data. The theory is `unencrypted_A + unencrypted_B = unencrypted_C; encrypted_A + encrypted_B = encrypted_C`. If this is possible, then you don't have to decrypt the data to work with it. The downside is that this requires a lot of compute, so there's usually just a partial homomorphic encryption used.

[microsoft/SEAL](https://github.com/microsoft/SEAL)

## Basics Designs and How We Got Them Wrong
Strongly opinionated talk. The speaker didn't necessarily disagreed with the principles, but he chose to show some issues they produce in specific scenarios. The takeaway was that there are no perfect solutions and there might be a reason to do something "different". I didn't like the talk much - making waves...

## Connect Remotely Like a Pro!
Session focused on accessing remote machines across the globe. Takeaways:
- Link aggregation - if you travel, you can connect to local network and then through cellular as well. This way you have a backup connection in case one fails. Preventing drops in the connection. Typically traveling in a train.
- Intel AMT (vPro) - remote access to the BIOS and the machine. Basically KVM over IP. You can reboot the machine, access the BIOS, etc. It's a hardware feature.
- TCP over ... - you can tunnel TCP over ICMP, DNS, Teams, etc. This way you can bypass firewalls and access the machine remotely. Useful for airports, hotels, etc. Speed is always limited by this.
- SSLH multiplexing - all the traffic is sent through one port. Then the multiplexer decides where to send the traffic based on the first packet.

## Going Schema-less
The talk was more introductory, then I expected. Yes, there are NoSQL databases... I like the 2 minutes about graph databases. If you want to go schema-less, Azure Cosmos DB is a perfect choice, because it's one offering that can be consumed through different APIs based on the type of data you have. It got me thinking about when to use a table storage (Azure Storage Account) and CosmosDB with Table API. Both perform differently, both cost differently, but the consumption from the point of developer is the samne.

## Advanced Event Sourcing
Advanced event sourcing is an approach where your data are stored as a sequence of events. This was demonstrated on a customer service ticket. A ticket is created -> accepted -> classified -> assigned -> ... The speaker was showing his open sourced tools that can be used for building such applications. He focused on how to set-up everything. This talk did not look very prepared and I don't took much from it.

[JasperFx/marten](https://github.com/JasperFx/marten) + [JasperFx/wolverine](https://github.com/JasperFx/wolverine)

# DAY 2
## .NET Aspire
Probably the easiest way to deploy your application. If you're developing an application today, usually it's a lot of different services (containers). Typically you have a backend and a frontend. These must be hosted, they must communicate together, they must be monitored, logs stored... .NET Aspire solves this out of box. It allows you to add all of your dependencies and monitor them in a browser UI dashboard. It can prepare the `.bicep` files for you for cloud deployments. It's a year old product, that helps you to go from zero to hero.

[dotnet/aspire](https://github.com/dotnet/aspire)
[What's new in .NET Aspire | DEMO](https://youtu.be/fiePiEc1qcU?si=xd-KEFwQcUnzS6Kz&t=309)

## Level up your GitHub copilot skill
I hoped to see some advanced tips and tricks how to get the most from a stupid LLM. But it was just a basic "how to use it" that you could summarize in 10 minutes.

## 15 years of insights from a TDD practitioner
This talk was delivered by author of FluentAssertions. You could know FluentAssestions from INT0010. I had two main takeaways:
1. All [test projects are suffixed `.Specs`](https://github.com/fluentassertions/fluentassertions/tree/develop/Tests) to indicate that they are not just tests, but rather documentation of what the project does.
2. Tests don't test individual methods or classes, but rather facts (example: `An_expired_token_is_not_valid`). Thats actually an implication of the first point.

[fluentassertions/fluentassertions](https://github.com/fluentassertions/fluentassertions)

## Transforming .NET Projects with AI Capabilities Using Semantic Kernel
Just a live demo of semantic kernel. Demonstration of enabling different plugins (agents) and adding a new capabilities to your chatbot. Semantic kernel allows you to teach your chatbot new skills.

[microsoft/semantic-kernel-starters](https://github.com/microsoft/semantic-kernel-starters/tree/main)

## Simplifying Our Code with Vertical Slice Architecture
This talk was delivered by the same person speaking about Advanced Event Sourcing and it was much better then that one. The speaker was comparing vertical slice architecture to clean (or onion) architecture. That one is still one of the most used ones - it's easy to understand and people tend to apply it. It produces some issues like for example if you have a complex use case that requires multiple entities to perform the operation, clean architecture forces you to access the entities through individual repositories. On the other hand, vertical slice architecture allows you to design against this use case from the start and get all the data with one **optimized** query.

You might argue that vertically slicing your application by features will result in duplicating code and if not handled, it probably will - that's something to keep in mind while designing the project.

[Vertical Slice Architecture and Comparison with Clean Architecture](https://mehmetozkaya.medium.com/vertical-slice-architecture-and-comparison-with-clean-architecture-76f813e3dab6)

## Code Complete: The Day AI Writes Your Next App!
This session was originally planned to be the conference opener and the one I was really looking for. Even though it was rescheduled to be the last one, I've enjoyed this one the most. The speaker demonstrated usage of LLM for generating code. Not Github Copilot, but rather his custom application generating code (and files). Basically a prompting solution, that was filling agents' templates (yes, we go back to the semantic kernel) and writing files to filesystem. Creating a new web app with basic CRUD interface was a matter of 5 minutes including unit tests. I'm well aware, that this won't code for you, but it was inspiring for me and I plan to take a deeper look at this.