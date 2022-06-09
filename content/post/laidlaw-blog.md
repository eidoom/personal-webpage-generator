+++
title = "Laidlaw Scholarship Experiences"
date = "2016-07-11"
categories = ["physics","professional development"]
tags = ["undergrad","st andrews","summer project","laidlaw"]
description = "A blog post for the Laidlaw Undergraduate Programme in Research and Leadership"
draft = false
+++

This blog post was featured on [Laidlaw Scholarship Experiences](https://laidlawscholarships.wp.st-andrews.ac.uk/2016/07/11/bec/).
It concerns [my project on photon BECs]({{< ref "bec-proj" >}}).

# BEC

Hello everyone, I hope you are all doing well.

(Do you get the joke of the title? It is condensed and I am studying condensates! No, OK, it is not very funny…)

I have thoroughly enjoyed reading through all the posts before mine. Thank you all for sharing your experiences and in such excellent prose. Everybody’s projects sound so interesting and I can feel the contagious enthusiasm in every post.

It has been seventeen weeks since we had our first leadership weekend, and I can’t believe how the time has flown. I highly value what I learned about leadership and research during the weekend, but I also appreciate the feeling of community with my fellow interns that I took away from it. Since starting my project, this has only strengthened as I have chanced upon new friends around St Andrews. The networking lunch of last Tuesday was one such delight and of course a welcome return to the excellent food provided at all CAPOD events!

I hope that now you won’t be too put off as I delve into what I’ve been up to the past few weeks. As a scientist, I feel I am in the minority of my cohort that might find it slightly more difficult to explain to everyone why their project is so awesome. Honestly, it is interesting! All right, on to the theoretical physics.

I have an intense interest in understanding how the universe fundamentally works. Quantum mechanics is a fascinating theory that tries to do just this and so I take great delight in exploring it.

Time for a quick jargon guide (sorry):

* BEC is an acronym for Bose-Einstein condensation (more on that to come).
* Absolute zero is −273.15 °C and is literally as cold as it gets.
* Spin is an intrinsic property of particles that is related to angular momentum.
* By particles, I mean things like protons, neutrons, electrons and atomic nuclei.
* Bosons are simply particles that have integer spin values of spin.
* Polarisation of light is familiar in the context of polarised sunglasses, which
* reduce glare by filtering out one polarisation.

One curious spectacle of our world that can be described through quantum mechanics is BEC. I am sure you are all familiar with the four fundamental states of matter: solid, liquid, gas and plasma. You might not be aware that if you push a system’s conditions (such as temperature, pressure and energy) to their extremes, other exotic states of matter are revealed. BEC is one such state, generally attained by cooling a gas of bosons (such as helium-4 atoms) to a temperature of near absolute zero. This induces the majority of the bosons to simultaneously occupy the lowest quantum state, which could loosely be described as the particles merging into a ‘super-particle’ as they all fall into the same single state. First theorised in 1924 by (you guessed it) Bose and Einstein, it was not experimentally observed until 70 years later when the first BEC was produced by Cornell and Wieman at the University of Colorada Boulder. The past two decades have seen our understanding of the state grow along with much laboratory observation of BEC of atomic nuclei, molecules and quasi-particles.

However, it was not until 2010 that the most common and familiar boson – light, in the form of photons – was successfully condensed. The challenge to this feat is that unlike with particles like atomic nuclei, photon number is not conserved. That is to say, photons are particles that can be created and destroyed – think of a light bulb creating light – whereas conservation laws prevent such creation and annihilation the other mentioned bosons. Thus, on cooling a system to attempt to condense a gas of photons, the photons will be absorbed into surrounding matter, leaving nothing to condense.

The photon BEC was achieved in an optical microcavity, the space between two very small and close mirrors, which was filled with dye molecules. To maintain a sufficient population of photons, a laser was used to pump the system. The gas of photons thermalises through interaction with the dye molecules to the temperature of the dye molecules, meaning the photon BEC could be produced at room temperature.

This exciting breakthrough has drawn the focus of much experimental and theoretical research, opening prospects to further probe the underlying nature of the universe and test our understanding in the context of quantum mechanics as well as its potential application in offering a new coherent high-frequency light source.

A theoretical model of the system exists; however, there has been limited progress in studying the effects of polarisation in photon BECs and the model lacks polarisation. As yet unpublished experiments at Imperial College London have shown that the way light is polarised changes on condensation. To investigate this phenomenon, I have been developing the model to include polarisation. What does this mean day to day? Well, I’ll break it down by week. (I should mention that I can by no means take full credit for my accomplishments so far – my supervisor, Jonathan, has been extremely supportive of my project and I am inspired by the insight he always shows during our discussions).

1. During the first week, I got myself up to speed with the work done on the existing non-equilibrium model of photon BEC. I read through the relevant papers, caught up with the required analytical physics and mathematical techniques required to describe such a system and followed the derivation of the quantum master equation of the system. Having accomplished this, I rederived the rate equations which describe the system through a semiclassical approximation of the master equation to convince myself that it was correct and that I understood it.
2. Now that I had the established physics behind me, I could move on to some new physics. Starting from those rate equations that I mentioned, I generalised them to allow the description of polarised light. It turned out that the best way to do this was to re-express the equations in spherical harmonic space (rather than angle space, which was the first thought). Working analytically (ie. with pen and paper), this inevitably meant that I had to wrestle with some horrible integrals to try to get a result. I did manage to solve most of the integrals by clever manipulation of and use of the orthogonality of the associated Legendre polynomials introduced by the spherical harmonics, but a couple of the integrals remained stubbornly intractable.
3. Feeling that analytics had taken me as far as it could, I turned to numerical methods to solve this final obstinate part of the equations (I hope I don’t sound too resentful about that). After a discussion, we had decided that the problem could be solved analytically, but that it would take a lot of work. Thankfully and somewhat surprisingly for me, the numeric result was simple and quick to obtain. This gave me a set of coupled equations which described the system including the effects of polarisation. Now all I had to do to investigate the behaviour was to solve them, so I started writing some code to do just this. Unfortunately, by the end of the week, I still had not managed to obtain the expected results.
4. Enter the debugging week. I went back through both my analytical work and all the code (and my supervisor proofread) to check for errors. Finding plenty (oh dear) I set about fixing them as I came across them. Finally, by the end of the week, I ran the code and it was with great joy that I saw the output graph of the populations had that lovely curve to a steady state that I had been looking for the last two weeks.
5. It is week five already? How on earth did that happen so quickly? Now that I have a working (I hope – I’ll do some tests after writing this) simulation of the system, I can start probing the physics of it and see if any interesting behaviour is apparent considering the polarisation.

Which brings me up to this point now. I feel that I have probably written a bit much already and I am excited to test my simulation, so I will leave you to do just that.

To conclude, some acknowledgements:

Thank you so much to CAPOD – especially Eilidh and Cat – for the leadership weekends, the networking events (of which I would love to attend more), the tremendous effort they put into this programme and for always brightening my day when we meet.

To Lord Laidlaw, I am indescribably grateful for your generosity in providing us all with the opportunity to dedicate our summer to research we care deeply about and to develop as tomorrow’s leaders.
